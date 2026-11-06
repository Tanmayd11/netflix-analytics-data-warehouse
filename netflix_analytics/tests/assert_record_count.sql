WITH staging_count AS (
    SELECT COUNT(*) AS total
    FROM {{ ref('stg_netflix_titles') }}
),

intermediate_count AS (
    SELECT COUNT(*) AS total
    FROM {{ ref('int_netflix_content') }}
)

SELECT
    staging_count.total AS staging_records,
    intermediate_count.total AS intermediate_records

FROM staging_count
CROSS JOIN intermediate_count

WHERE staging_count.total != intermediate_count.total