{% macro transform_column_names(relation, year, category='Population_Generale') %}
    {% set year_suffix = (year|string)[2:] %}

    {# Récupération du mapping des noms de colonnes #}
    {% set column_mapping_query %}
        select distinct 
            champ_insee_transfo,
            clef_json_transfo
        from {{ source('sources', 'champs_disponibles_sources') }}
        where categorie = '{{ category }}'
    {% endset %}

    {# Création du dictionnaire de mapping #}
    {% set mapping_results = run_query(column_mapping_query) %}
    {% set column_name_mapping = {} %}
    {% for result in mapping_results %}
        {% do column_name_mapping.update({result[0]: result[1]}) %}
    {% endfor %}

    {# Transformation des noms de colonnes #}
    {% set columns = adapter.get_columns_in_relation(relation) %}
    {% set transformed_columns = [] %}

    {% for column in columns %}
        {% set original_column_name = column.name %}
        
        {# Traitement spécial pour CODGEO #}
        {% if original_column_name == 'CODGEO' %}
            {% do transformed_columns.append('\"' ~ original_column_name ~ '\" as \"' ~ original_column_name ~ '\"') %}
        
        {# Traitement des colonnes de population et autres métriques #}
        {% elif original_column_name.startswith('P' ~ year_suffix ~ '_') or original_column_name.startswith('C' ~ year_suffix ~ '_') %}
            {% set base_column_name = original_column_name[0] ~ '_' ~ original_column_name.split('_')[1:] | join('_') %}
            {% if base_column_name in column_name_mapping %}
                {% do transformed_columns.append('\"' ~ original_column_name ~ '\" as \"' ~ column_name_mapping[base_column_name] ~ '\"') %}
            {% endif %}
        {% endif %}
    {% endfor %}

    {# Génération de la requête finale #}
    select
        {{ transformed_columns | join(',\n        ') }},
        {{ year }} as annee
    from {{ relation }}
{% endmacro %}

{% macro transform_column_names_robust(relation, year, category, all_possible_columns) %}
    {% set year_suffix = (year|string)[2:] %}

    {# Récupération du mapping des noms de colonnes #}
    {% set column_mapping_query %}
        select distinct 
            champ_insee_transfo,
            clef_json_transfo
        from {{ source('sources', 'champs_disponibles_sources') }}
        where categorie = '{{ category }}'
    {% endset %}

    {# Création du dictionnaire de mapping #}
    {% set mapping_results = run_query(column_mapping_query) %}
    {% set column_name_mapping = {} %}
    {% for result in mapping_results %}
        {% do column_name_mapping.update({result[0]: result[1]}) %}
    {% endfor %}

    {# Créer le mapping inverse pour retrouver les colonnes originales #}
    {% set inverse_mapping = {} %}
    {% for original_col, transformed_col in column_name_mapping.items() %}
        {% do inverse_mapping.update({transformed_col: original_col}) %}
    {% endfor %}

    {# Récupération des colonnes existantes dans la relation #}
    {% set columns = adapter.get_columns_in_relation(relation) %}
    {% set existing_columns = [] %}
    {% for column in columns %}
        {% do existing_columns.append(column.name) %}
    {% endfor %}

    {# Génération de la requête avec toutes les colonnes possibles #}
    select
        "CODGEO",
        {% for target_col in all_possible_columns %}
            {% if target_col in inverse_mapping %}
                {% set base_col = inverse_mapping[target_col] %}
                {% set original_col = base_col.replace('XX', year_suffix) %}
                {% if original_col in existing_columns %}
                    "{{ original_col }}" as "{{ target_col }}"
                {% else %}
                    null as "{{ target_col }}"
                {% endif %}
            {% else %}
                null as "{{ target_col }}"
            {% endif %}
            {% if not loop.last %},{% endif %}
        {% endfor %},
        {{ year }} as annee
    from {{ relation }}
{% endmacro %}