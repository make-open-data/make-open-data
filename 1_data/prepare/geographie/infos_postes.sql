{{ config(materialized='table') }}

with format_cog_poste as (
    select DISTINCT
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        CASE

            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 3) IN ('200', '201') THEN '2A'
            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') FROM 1 FOR 2) = '20' THEN '2B'
            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') FROM 1 FOR 5) = '97133' THEN '977' -- Saint Barthelemy, code postal 97133, code dept insee 977
			WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') FROM 1 FOR 5) = '97150' THEN '978' -- Saint Martin, code postal 97150, code dept insee 978
			WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') FROM 1 FOR 5) = '98799' THEN '989' -- Île de Clipperton, code postal 97150, code dept insee 978
			WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 2) IN ('97', '98') THEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 3)

            ELSE SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 2)

        END as code_departement
    from {{ ref('cog_poste')}} as cog_poste
),

join_departements as (
    select
        format_cog_poste.*,
        cog_departements.nom as nom_departement,
        cog_departements.region as code_region
    from format_cog_poste
    left join {{ source('sources', 'cog_departements')}} cog_departements on format_cog_poste.code_departement = cog_departements.code
),

join_regions as (
    select
        join_departements.*,
        cog_regions.nom as nom_region
    from join_departements
    left join {{ source('sources', 'cog_regions')}} cog_regions on join_departements.code_region = cog_regions.code
)

select *
from join_regions
