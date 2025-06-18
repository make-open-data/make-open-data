{% macro generate_evolution_table(category, start_year, end_year) %}
    {# Special handling for problematic categories #}
    {% if category == 'Emplois' %}
        {{ generate_evolution_table_single_source(category, start_year, end_year, 'base_cc_caract_emp') }}
    {% else %}
        {{ generate_evolution_table_generic(category, start_year, end_year) }}
    {% endif %}
{% endmacro %}

{% macro generate_evolution_table_single_source(category, start_year, end_year, forced_table) %}
    {# Génération de la liste des années #}
    {% set years = [] %}
    {% for year in range(start_year, end_year + 1) %}
        {% do years.append(year) %}
    {% endfor %}

    {# Force une seule table source #}
    {% set source_table_names = [forced_table] %}    {# Récupération de toutes les colonnes possibles pour cette catégorie #}
    {% set all_columns_query %}
        select distinct clef_json_transfo
        from {{ source('sources', 'champs_disponibles_sources') }}
        where categorie = '{{ category }}'
        and base_table_source = '{{ forced_table }}'
        order by clef_json_transfo
    {% endset %}

    {% set all_columns_result = run_query(all_columns_query) %}
    {% set all_possible_columns = [] %}
    {% for col in all_columns_result %}
        {% do all_possible_columns.append(col[0]) %}
    {% endfor %}

    {# Génération des CTEs avec transformation de colonnes #}
    with
    {% for year in years %}
        {{ forced_table }}_{{ year }} as (
            {{ transform_column_names_robust(
                source('sources', forced_table ~ '_' ~ year),
                year,
                category,
                all_possible_columns
            ) }}
        ),
    {% endfor %}

    {{ forced_table }}_unified as (
        {% for year in years %}
            {% if not loop.first %}union all{% endif %}
            select 
                "CODGEO",
                {% for col in all_possible_columns %}
                    "{{ col }}",
                {% endfor %}
                annee
            from {{ forced_table }}_{{ year }}
        {% endfor %}
    )

    select
        {{ forced_table }}_unified."CODGEO",
        {% for col in all_possible_columns %}
            {{ forced_table }}_unified."{{ col }}"{% if not loop.last %},{% endif %}
        {% endfor %}
        {% if all_possible_columns|length > 0 %},{% endif %}
        {{ forced_table }}_unified.annee
    from {{ forced_table }}_unified

{% endmacro %}

{% macro generate_evolution_table_generic(category, start_year, end_year) %}
    {# Génération de la liste des années #}
    {% set years = [] %}
    {% for year in range(start_year, end_year + 1) %}
        {% do years.append(year) %}
    {% endfor %}    {# Récupération des tables sources valides pour la catégorie donnée #}
    {% set source_tables_query %}
        select distinct base_table_source 
        from {{ source('sources', 'champs_disponibles_sources') }} 
        where categorie = '{{ category }}'
        and base_table_source is not null
        and base_table_source != ''
        and base_table_source != 'None'
        order by base_table_source
        limit 1
    {% endset %}

    {% set source_tables = run_query(source_tables_query) %}
    {% set source_table_names = [] %}
    {% for table in source_tables %}
        {% if table[0] and table[0] != 'None' and table[0] != '' %}
            {% do source_table_names.append(table[0]) %}
        {% endif %}    {% endfor %}

    {% if source_table_names|length == 0 %}
        {# Retourner une table vide avec juste les colonnes essentielles #}
        select 
            null::text as "CODGEO",
            null::integer as annee
        where false
    {% else %}    {# Récupération de toutes les colonnes possibles pour cette catégorie #}
    {% set all_columns_query %}
        select distinct clef_json_transfo
        from {{ source('sources', 'champs_disponibles_sources') }}
        where categorie = '{{ category }}'
        and base_table_source is not null
        and base_table_source != ''
        and base_table_source != 'None'
        order by clef_json_transfo
    {% endset %}

    {% set all_columns_result = run_query(all_columns_query) %}
    {% set all_possible_columns = [] %}
    {% for col in all_columns_result %}
        {% do all_possible_columns.append(col[0]) %}
    {% endfor %}

    {# Génération des CTEs avec transformation de colonnes #}
    with
    {% for table_name in source_table_names %}
        {% for year in years %}
            {{ table_name }}_{{ year }} as (
                {{ transform_column_names_robust(
                    source('sources', table_name ~ '_' ~ year),
                    year,
                    category,
                    all_possible_columns
                ) }}
            ),
        {% endfor %}
    {% endfor %}

    {# Union des données par table source #}
    {% for table_name in source_table_names %}
    {{ table_name }}_unified as (
        {% for year in years %}
            {% if not loop.first %}union all{% endif %}
            select 
                "CODGEO",
                {% for col in all_possible_columns %}
                    "{{ col }}",
                {% endfor %}
                annee,
                '{{ table_name }}' as source_table
            from {{ table_name }}_{{ year }}
        {% endfor %}
    ){% if not loop.last %},{% endif %}
    {% endfor %}

    {# Si plusieurs tables sources, les unifier #}
    {% if source_table_names|length > 1 %}
    ,all_data_unified as (
        {% for table_name in source_table_names %}
            {% if not loop.first %}union all{% endif %}
            select 
                "CODGEO",
                {% for col in all_possible_columns %}
                    "{{ col }}",
                {% endfor %}
                annee
            from {{ table_name }}_unified
        {% endfor %}
    )
    {% endif %}

    {# Requête finale avec jointure des tables unifiées #}
    select
        {% if source_table_names|length == 1 %}
            {{ source_table_names[0] }}_unified."CODGEO",
            {% for col in all_possible_columns %}
                {{ source_table_names[0] }}_unified."{{ col }}"{% if not loop.last %},{% endif %}
            {% endfor %}
            {% if all_possible_columns|length > 0 %},{% endif %}
            {{ source_table_names[0] }}_unified.annee
        from {{ source_table_names[0] }}_unified
        {% else %}
            all_data_unified."CODGEO",
            {% for col in all_possible_columns %}
                all_data_unified."{{ col }}"{% if not loop.last %},{% endif %}
            {% endfor %}
            {% if all_possible_columns|length > 0 %},{% endif %}
            all_data_unified.annee
        from all_data_unified
        {% endif %}

    {% endif %}

{% endmacro %}