{{ config(materialized='table', schema='prepare') }}

with infos_communes as (
    select 
        LPAD(CAST(cog_communes.code as TEXT), 5, '0') as code_commune,
        cog_communes.nom as nom_commune,
        cog_communes.arrondissement as code_arrondissement,
        cog_communes.departement as code_departement,
        cog_communes.region as code_region,
        cog_departements.nom as nom_departement,
        cog_regions.nom as nom_region,
        coalesce(shape_epci."SIREN_EPCI", scot_mapping."SIREN EPCI") as siren_epci,
        scot_mapping."SCoT" as nom_scot
    from {{ source('sources', 'cog_communes') }} as cog_communes
    left join {{ source('sources', 'cog_departements') }} as cog_departements 
        on cog_departements.code = cog_communes.departement
    left join {{ source('sources', 'cog_regions') }} as cog_regions 
        on cog_regions.code = cog_communes.region
    left join {{ source('sources', 'shape_commune_2024') }} as shape_epci 
        on LPAD(CAST(cog_communes.code as TEXT), 5, '0') = shape_epci."INSEE_COM"
    left join {{ source('sources', 'communes_to_scot') }} as scot_mapping 
        on LPAD(CAST(cog_communes.code as TEXT), 5, '0') = LPAD(CAST(scot_mapping."INSEE commune" AS TEXT), 5, '0')
    where cog_communes.type in ('commune-actuelle', 'arrondissement-municipal')
),

evolution_data as (
    {{ generate_evolution_table(
        category='Population_Generale',
        start_year=2016,
        end_year=2021
    ) }}
)

select 
    e.*,
    i.nom_commune,
    i.code_departement,
    i.siren_epci,
    i.nom_departement,
    i.code_region,
    i.nom_region,
    i.nom_scot
from evolution_data e
left join infos_communes i on ltrim(e."CODGEO", '0') = i.code_commune