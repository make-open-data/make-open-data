{% macro get_millesimes_dvf_from_sources(env) %}
    {% set suffix = '' if env == 'prod' else '_dev' %}
    {% set exclude_dev = 'AND table_name NOT ILIKE \'%_dev%\'' if env == 'prod' else '' %}

    {% set query %}
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'sources'
        AND table_name LIKE 'dvf_%'
        {{ exclude_dev }}
    {% endset %}

    {% set results = run_query(query) %}

    {% if results is not none %}
        {% set table_names = [] %}
        {% for row in results %}
            {% do table_names.append(row['table_name']) %}
        {% endfor %}
        {{ return(table_names | unique | sort) }}
    {% else %}
        {{ return([]) }}
    {% endif %}
{% endmacro %}
