{% set year = "2016"%}
{% set year_two_digits = "16"%}
{% set base_table = "base_cc_emploi_pop_active" %}


{% set tablename = base_table + '_' + year%}


{% set colonnes_mapping_query %}
    select clef_json_transfo, champ_insee_transfo 
    from {{ source("sources", 'champs_disponibles_sources') }}
    where 
        (base_table_source = 'base_cc_emploi_pop_active') 
        and (cast(premiere_annee_presence as int) <= {{ year|int }})
        and (cast(derniere_annee_presence as int) >= {{ year|int }})
{% endset %}

{% set colonnes_mapping_results = run_query(colonnes_mapping_query) %}

{% set colonnes_origine = [] %}
{% set colonnes_destination = [] %}

{% for row in colonnes_mapping_results %}
    {% do colonnes_origine.append(row[1]) %}
    {% do colonnes_destination.append(row[0]) %}
{% endfor %}

{% set colonnes_destination_curated = [] %}


{% for column in colonnes_destination %}
    {% do column_curated = column.replace('c_emplois_au_lieu_travail_', '') %}
    {% do colonnes_destination_curated.append(column_curated) %}
{% endfor %}


{%- set all_columns = adapter.get_columns_in_relation(source('sources', 'base_cc_emploi_pop_active_2016')) %}


with first_rename as (
    select 
    {%- for col in all_columns %}
        "{{ col.name }}" as "{{ col.name.replace(year_two_digits, '') }}"
        {% if not loop.last %} , {% endif %}
    {%- endfor %} 
    from {{ source('sources', tablename) }}
), second_rename as (
    select 
    "CODGEO",
    {%- for origin, destination in zip(colonnes_origine, colonnes_destination_curated) %}
        "{{ row[1] }}" as "{{ row[0] }}"
        {% if not loop.last %} , {% endif %}
    {%- endfor %} 
    from first_rename
) 

select * from second_rename