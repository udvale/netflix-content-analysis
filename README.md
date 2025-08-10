# Netflix Content Analysis
## Overview
This project analyzes Netflix’s global content from 2015–2024, focusing on genre performance, country output, and content strategy over time.
The goal is to identify trends that could inform business decisions, content acquisition, and production strategy.

**Key Questions**:
1. What genres perform best globally?
2. Which countries produce the highest-rated content?
3. How has Netflix’s mix of movies vs. TV shows evolved over time?
4. What are the top-performing titles within each top genre?

Final interactive dashboard: https://public.tableau.com/app/profile/udval.enkhtaivan/viz/NetflixContentAnalysis_17548660855840/Dashboard1

## Dataset
Source: https://www.kaggle.com/datasets/bhargavchirumamilla/netflix-movies-and-tv-shows-till-2025

#### Files used:
```bash
netflix_movies_detailed_up_to_2025.csv
netflix_tv_shows_detailed_up_to_2025.csv
```

#### Columns kept for analysis:
```bash
title, type, release_year, rating, vote_count, country, genres
```

## Process
#### 1. Data Cleaning (Python / Pandas)
- Merged Movies and TV Shows datasets.
- Standardized column names & formats.
- Removed missing/invalid release years.
- Split multi-value fields (genres, country) into junction tables for relational database use.
- Added primary key content_id.

#### 2. Schema
   
   <img width="674" height="336" alt="Screenshot 2025-08-10 160215" src="https://github.com/user-attachments/assets/7baadb48-b66a-4899-9411-9750ab6e1ea1" />
   
#### 3. SQL Analysis
- Top 10 Genres Globally
- Country Performance (Weighted Rating)
- Movies vs. TV Shows Over Time
- Top 5 Genres per Category & Top Titles in Each

## Results & Insights
1. **Top Genres Globally**: Drama, Comedy, Documentary lead in both volume & performance.
2. **Country Performance**: Smaller markets like Pakistan & South Korea rank highly in weighted ratings.
3. **Strategy Over Time**: Movies outnumber TV shows yearly; TV shows have higher production investment but fewer releases.
4. **High-Value Titles**: Popular animated and drama series dominate genre leaders.
























