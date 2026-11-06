{{ config(materialized='table') }}

SELECT
    release_year,

    COUNT(*) AS total_titles,

    COUNT(*) FILTER (
        WHERE content_type = 'Movie'
    ) AS total_movies,

    COUNT(*) FILTER (
        WHERE content_type = 'TV Show'
    ) AS total_tv_shows,

    COUNT(DISTINCT country_cleaned) AS total_countries

FROM {{ ref('int_netflix_content') }}

WHERE release_year IS NOT NULL

GROUP BY release_year
ORDER BY release_year DESC