/* ================================================================
   NETFLIX ANALYSIS — TABLES, INDEXES, AND CORE QUERIES (Postgres)
   ================================================================ */

/* ---------- TABLES ---------- */

CREATE TABLE netflix_content (
  content_id    INT PRIMARY KEY,
  title         TEXT NOT NULL,
  type          TEXT NOT NULL,           
  release_year  INT  NOT NULL,
  rating        NUMERIC,                  -- audience rating (0–10)
  vote_count    INT  DEFAULT 0
);

CREATE TABLE content_genres (
  content_id    INT NOT NULL,
  genre         TEXT NOT NULL
);

CREATE TABLE content_countries (
  content_id    INT NOT NULL,
  country       TEXT NOT NULL
);

/* ---------- HELPFUL INDEXES ---------- */
CREATE INDEX IF NOT EXISTS idx_nc_year_type   ON netflix_content (release_year, type);
CREATE INDEX IF NOT EXISTS idx_nc_votes       ON netflix_content (vote_count);
CREATE INDEX IF NOT EXISTS idx_genres_genre   ON content_genres (genre);
CREATE INDEX IF NOT EXISTS idx_countries_ctry ON content_countries (country);


/* ================================================================
   4 CORE QUERIES (used for Tableau)
   Using vote-weighted averages to reduce small-sample bias.
   ================================================================ */

/* ---------- Q1: Top 10 Genres Globally (vote-weighted) ---------- */
SELECT
  g.genre,
  COUNT(*)                                   AS total_titles,
  ROUND(AVG(c.rating)::numeric, 2)           AS avg_rating,
  ROUND(
    SUM(c.rating * c.vote_count)::numeric
    / NULLIF(SUM(c.vote_count), 0)
  , 3)                                       AS weighted_rating
FROM content_genres g
JOIN netflix_content c ON c.content_id = g.content_id
WHERE c.rating > 0
GROUP BY g.genre
HAVING COUNT(*) >= 100 AND SUM(c.vote_count) > 0      -- adjust threshold if needed
ORDER BY weighted_rating DESC, total_titles DESC
LIMIT 10;


/* ---------- Q2: Country Performance (vote-weighted) ---------- */
SELECT
  cc.country,
  COUNT(*)                                   AS total_titles,
  ROUND(
    SUM(c.rating * c.vote_count)::numeric
    / NULLIF(SUM(c.vote_count), 0)
  , 3)                                       AS weighted_avg_rating,
  COUNT(*) FILTER (WHERE c.type = 'Movie')   AS movie_count,
  COUNT(*) FILTER (WHERE c.type = 'TV Show') AS tv_count
FROM content_countries cc
JOIN netflix_content c ON c.content_id = cc.content_id
WHERE c.rating > 0
GROUP BY cc.country
HAVING COUNT(*) >= 200 AND SUM(c.vote_count) > 0      -- adjust threshold if needed
ORDER BY weighted_avg_rating DESC, total_titles DESC;


/* ---------- Q3: Movies vs TV Shows by Year (grouped bars) ---------- */
SELECT
  c.release_year,
  c.type,
  COUNT(*) AS title_count,
  ROUND(
    100.0 * COUNT(*)::numeric
    / NULLIF(SUM(COUNT(*)) OVER (PARTITION BY c.release_year), 0)
  , 1) AS share_pct
FROM netflix_content c
WHERE c.rating > 0
GROUP BY c.release_year, c.type
ORDER BY c.release_year, c.type;


/* ---------- Q4: Top-5 Genres per Type → Top-3 Titles (dedup titles) ---------- */
WITH genre_scores AS (
  SELECT
    g.genre,
    c.type,
    COUNT(*)                                   AS n_titles,
    ROUND(AVG(c.rating)::numeric, 2)           AS avg_rating,
    ROUND(
      SUM(c.rating * c.vote_count)::numeric
      / NULLIF(SUM(c.vote_count), 0)
    , 3)                                       AS weighted_rating
  FROM content_genres g
  JOIN netflix_content c ON c.content_id = g.content_id
  WHERE c.rating > 0
  GROUP BY g.genre, c.type
  HAVING COUNT(*) >= 100 AND SUM(c.vote_count) > 0
),
top5_genres AS (
  SELECT *
  FROM (
    SELECT
      genre, type, n_titles, avg_rating, weighted_rating,
      ROW_NUMBER() OVER (PARTITION BY type ORDER BY weighted_rating DESC, n_titles DESC) AS rn
    FROM genre_scores
  ) s
  WHERE rn <= 5
),
-- choose each title's single "best" genre (avoid duplicates across multiple genres)
titles_best_genre AS (
  SELECT *
  FROM (
    SELECT
      c.title, c.type, g.genre, c.release_year, c.rating, c.vote_count,
      -- per-title weighted score with m=100 smoothing against global mean C
      ((c.vote_count::numeric / (c.vote_count::numeric + 100)) * c.rating::numeric
       + (100::numeric / (c.vote_count::numeric + 100)) * (
           SELECT AVG(rating)::numeric FROM netflix_content WHERE rating > 0
         )
      ) AS title_weighted_rating,
      ROW_NUMBER() OVER (
        PARTITION BY c.type, c.title
        ORDER BY
          ((c.vote_count::numeric / (c.vote_count::numeric + 100)) * c.rating::numeric
           + (100::numeric / (c.vote_count::numeric + 100)) * (
               SELECT AVG(rating)::numeric FROM netflix_content WHERE rating > 0
             )
          ) DESC,
          c.vote_count DESC,
          c.release_year DESC
      ) AS genre_pick
    FROM netflix_content c
    JOIN content_genres g ON g.content_id = c.content_id
    WHERE c.rating > 0 AND c.vote_count >= 100
  ) x
  WHERE genre_pick = 1
),
titles_ranked AS (
  SELECT
    tb.type,
    tb.genre,
    tb.title,
    tb.release_year,
    tb.rating,
    tb.vote_count,
    tb.title_weighted_rating,
    ROW_NUMBER() OVER (
      PARTITION BY tb.type, tb.genre
      ORDER BY tb.title_weighted_rating DESC, tb.vote_count DESC, tb.release_year DESC
    ) AS rnk
  FROM titles_best_genre tb
  JOIN top5_genres tg
    ON tg.type = tb.type AND tg.genre = tb.genre
)
SELECT
  tg.type,
  tg.genre,
  tg.weighted_rating    AS genre_weighted_rating,
  tg.n_titles           AS genre_titles,
  tr.rnk                AS title_rank_within_genre,
  tr.title,
  tr.release_year,
  tr.rating,
  tr.vote_count,
  tr.title_weighted_rating
FROM titles_ranked tr
JOIN top5_genres tg
  ON tg.type = tr.type AND tg.genre = tr.genre
WHERE tr.rnk <= 3
ORDER BY tg.type, tg.weighted_rating DESC, tg.genre, tr.rnk;
