SELECT *
FROM {{ ref('int_netflix_content') }}
WHERE release_year < 1925
   OR release_year > EXTRACT(YEAR FROM CURRENT_DATE)