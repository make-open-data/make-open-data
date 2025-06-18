{{ config(materialized='table', schema='prepare') }}

with commune_data as (
    select * from {{ ref('Population_Generale_communes_evolution') }}
)

select 
    code_departement,
    code_region,
    nom_departement,
    nom_region,
    annee
    {%- set columns = adapter.get_columns_in_relation(ref('Population_Generale_communes_evolution')) %}
    {%- for col in columns %}
    {%- if col.name not in ['CODGEO', 'annee', 'code_departement', 'code_region', 'nom_departement', 'nom_region', 'code_commune', 'nom_commune', 'nom_scot', 'siren_epci'] %}
    ,sum(case when "{{ col.name }}" ~ '^[0-9]+\.?[0-9]*$' 
        then nullif("{{ col.name }}", '')::numeric 
        else null end) as "{{ col.name }}"
    {%- endif %}
    {%- endfor %}
from commune_data
group by 
    code_departement,
    code_region,
    nom_departement,
    nom_region,
    annee
order by 
    code_region,
    code_departement,
    annee