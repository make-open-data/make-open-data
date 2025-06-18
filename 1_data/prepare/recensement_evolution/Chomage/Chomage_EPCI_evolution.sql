{{ config(materialized='table', schema='prepare') }}

with commune_data as (
    select * from {{ ref('Chomage_communes_evolution') }}
)

select 
    siren_epci,
    annee
    {%- set columns = adapter.get_columns_in_relation(ref('Chomage_communes_evolution')) %}
    {%- for col in columns %}
    {%- if col.name not in ['CODGEO', 'annee', 'code_departement', 'code_region', 'nom_departement', 'nom_region', 'code_commune', 'nom_commune', 'nom_scot', 'siren_epci'] %}
    ,sum(case when "{{ col.name }}" ~ '^[0-9]+\.?[0-9]*$' 
        then nullif("{{ col.name }}", '')::numeric 
        else null end) as "{{ col.name }}"
    {%- endif %}
    {%- endfor %}
from commune_data
where siren_epci is not null
group by 
    siren_epci,
    annee
order by 
    siren_epci,
    annee