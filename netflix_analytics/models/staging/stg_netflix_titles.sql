SELECT
    show_id,
    type,
    title,
    director,
    "cast" AS cast_members,
    country,
    TRY_STRPTIME(
        TRIM(date_added),
        '%B %d, %Y'
    )::DATE AS date_added,
    release_year,
    rating,
    duration,
    listed_in,
    description

FROM {{ source('netflix_raw', 'raw_netflix_titles') }}