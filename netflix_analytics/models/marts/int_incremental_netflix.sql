{{
    config(
        materialized='incremental',
        unique_key='show_id'
    )
}}

SELECT
    show_id,
    type,
    title,
    director_cleaned,
    country_cleaned,
    release_year,
    date_added

FROM {{ ref('int_netflix_content') }}

{% if is_incremental() %}

WHERE show_id NOT IN (
    SELECT show_id
    FROM {{ this }}
)

{% endif %}