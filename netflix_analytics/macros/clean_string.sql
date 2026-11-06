{% macro clean_string(column_name) %}

    CASE
        WHEN {{ column_name }} IS NULL
             OR TRIM({{ column_name }}) = ''
        THEN 'Unknown'
        ELSE TRIM({{ column_name }})
    END

{% endmacro %}