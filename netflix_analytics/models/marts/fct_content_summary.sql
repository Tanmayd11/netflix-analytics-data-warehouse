
{{ config(materialized='table') }}

SELECT
    COUNT(*) AS total_titles,

    COUNT(*) FILTER (
        WHERE content_type = 'Movie'
    ) AS total_movies,

    COUNT(*) FILTER (
        WHERE content_type = 'TV Show'
    ) AS total_tv_shows,

    COUNT(DISTINCT country_cleaned) AS total_countries,

    COUNT(DISTINCT release_year) AS total_release_years,

    COUNT(*) FILTER (
        WHERE director_cleaned = 'Unknown'
    ) AS missing_director_records,

    COUNT(*) FILTER (
        WHERE country_cleaned = 'Unknown'
    ) AS missing_country_records

FROM {{ ref('int_netflix_content') }}

