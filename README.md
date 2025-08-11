# Netflix Content Analysis: [Tableau Dashboard](https://public.tableau.com/app/profile/udval.enkhtaivan/viz/NetflixContentAnalysis_17548660855840/Dashboard1)
## Overview
This project examines Netflix’s global content from 2010 to mid-2025, focusing on genre performance, country output, and content strategy over time. The aim was to identify key patterns and shifts in these areas to better understand Netflix’s content trends. 

**Key Questions**:
1. What genres perform best globally?
2. Which countries produce the highest-rated content?
3. How has Netflix’s mix of movies vs. TV shows evolved over time?
4. What are the top-performing titles within each top genre?

## Dataset
Source: [Netflix Movies and TV Shows till 2025](https://www.kaggle.com/datasets/bhargavchirumamilla/netflix-movies-and-tv-shows-till-2025)
This dataset contains two CSV files:
1. ``` netflix_movies_detailed_up_to_2025.csv ``` - Includes detailed information on Netflix Movies such as:
   - ```show_id``` - Unique identifier of the Movie
   - ```type``` - Content type (Movie)
   - ```title``` - Name of the Movie
   - ```director``` -  Director(s) of the Movie (if available)
   - ```cast``` -  Main actors/actresses featured in the Movie
   - ```date_added``` -  Date the Movie was added to Netflix
   - ```release_year``` - Year the Movie was originally released
   - ```rating``` -  Audience rating score (0–10)
   - ```duration``` - Runtime of the Movie (was ```NULL``` in the Movie)
   - ```genres``` - Genre(s) of the Movie
   - ```language``` - Primary language(s)
   - ```description``` - Short plot or summary
   - ```popularity``` - Popularity score based on audience engagement
   - ```vote_count``` - Number of audience ratings submitted
   - ```vote_average``` - Average rating based on audience votes
   - ```budget``` - Production budget (in USD, if available)
   - ```revenue``` - Box office or total revenue

2. ``` netflix_tv_shows_detailed_up_to_2025.csv ``` - Includes detailed information on Netflix TV shows, such as:
   - ```show_id``` - Unique identifier for the TV Show 
   - ```type``` - Content type (TV Show)
   - ```title``` - Name of the TV Show
   - ```director``` -  Director(s) of the TV Show (if available)
   - ```cast``` -  Main actors/actresses featured in the TV Show
   - ```date_added``` -  Date the TV Show was added to Netflix
   - ```release_year``` - Year the TV Show was originally released
   - ```rating``` -  Audience rating score (0–10)
   - ```duration``` - Runtime of the TV Show (in seasons)
   - ```genres``` - Genre(s) of the TV Show
   - ```language``` - Primary language(s)
   - ```description``` - Short plot or summary
   - ```popularity``` - Popularity score based on audience engagement
   - ```vote_count``` - Number of audience ratings submitted
   - ```vote_average``` - Average rating based on audience votes

For this analysis and for consistency, I focused on ```title, type, release_year, rating, vote_count, country, genres``` from both files, as these fields directly relate to the questions I aimed to answer. 
##### Schema:

<img width="674" height="336" alt="Screenshot 2025-08-10 160215" src="https://github.com/user-attachments/assets/7baadb48-b66a-4899-9411-9750ab6e1ea1" />

## Process
#### 1. Data Cleaning and Structuring:
- Standardized country names and genre labels.
- Split multiple genres per title into individual records for accurate aggregation.
- Removed entries with missing or invalid rating or release_year.
- Standardized column names & formats

#### 2. Using SQL, I aggregated and filtered the data to answer the key questions for analysis:
- Top genres globally using vote-weighted ratings to reduce bias from low-vote titles.
- Country-level performance, comparing weighted ratings and production counts.
- Movies vs TV Shows trends by year and share percentage.
- Top titles in top-performing genres for each type.

#### 3. The processed data was visualized in Tableau through an interactive dashboard, featuring:
- Genre Trends Over Time – Showing shifts in popularity from 2010 to mid-2025.
- Top Producing Countries – Ranking countries by number of titles.
- Movies vs TV Shows – Tracking proportional changes across years.
- Top Genres & Titles – Highlighting the best-performing genres and their standout titles.


## Dashboard Visualization 

<img width="1718" height="1030" alt="Dashboard 1" src="https://github.com/user-attachments/assets/c82056c7-1061-4c2e-a110-ec235dcd902d" />









