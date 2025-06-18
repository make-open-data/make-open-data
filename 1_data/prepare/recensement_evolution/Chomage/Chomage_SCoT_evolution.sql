{{ config(materialized='table', schema='prepare') }}

with commune_data as (
    select * from {{ ref('Chomage_communes_evolution') }}
)

select 
    nom_scot,
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
where nom_scot is not null
group by 
    nom_scot,
    annee
order by 
    nom_scot,
    annee