
/*
    Merge all data to commune level


    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with format_cog_poste as (
    select DISTINCT
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        CASE 
            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 3) IN ('200', '201') THEN '2A'
            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 1) = '2' THEN '2B'
            ELSE SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 2)
        END as code_departement
    from sources.cog_poste
),

join_departements as (
    select 
        format_cog_poste.*,
        sources.cog_departements.nom as nom_departement,
        sources.cog_departements.region as code_region
    from format_cog_poste
    left join sources.cog_departements on format_cog_poste.code_departement = sources.cog_departements.code
),

join_regions as (
    select 
        join_departements.*,
        sources.cog_regions.nom as nom_region
    from join_departements
    left join sources.cog_regions on join_departements.code_region = sources.cog_regions.code
)

select *
from join_regions