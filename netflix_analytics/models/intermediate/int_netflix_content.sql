{{ config(materialized='view') }}

SELECT
    show_id,
    type,
    title,

    {{ clean_string('director') }} AS director_cleaned,

    {{ clean_string('cast_members') }} AS cast_members,

    {{ clean_string('country') }} AS country_cleaned,

    date_added,
    release_year,
    rating,
    duration,
    listed_in,
    description,

    CASE
        WHEN type = 'Movie' THEN 'Movie'
        WHEN type = 'TV Show' THEN 'TV Show'
        ELSE 'Unknown'
    END AS content_type

FROM {{ ref('stg_netflix_titles') }}