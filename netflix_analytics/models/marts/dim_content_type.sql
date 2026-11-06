{{ config(materialized='table') }}

SELECT
    content_type,
    COUNT(*) AS total_titles,

    COUNT(DISTINCT release_year) AS total_release_years,

    COUNT(*) FILTER (
        WHERE director_cleaned = 'Unknown'
    ) AS missing_director_records,

    COUNT(*) FILTER (
        WHERE country_cleaned = 'Unknown'
    ) AS missing_country_records

FROM {{ ref('int_netflix_content') }}

GROUP BY content_type
ORDER BY total_titles DESC