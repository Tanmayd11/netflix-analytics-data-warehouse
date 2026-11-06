SELECT *
FROM {{ ref('fct_content_summary') }}

WHERE total_titles != total_movies + total_tv_shows