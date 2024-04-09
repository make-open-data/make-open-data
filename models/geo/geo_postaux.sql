
/*
    Merge all data to commune level


    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with source_data as (
    select DISTINCT
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        CASE 
            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 3) IN ('200', '201') THEN '2A'
            WHEN SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 1) = '2' THEN '2B'
            ELSE SUBSTRING(LPAD(CAST(code_postal AS TEXT), 5, '0') for 2)
        END as code_departement
    from codes_postaux
),

joined_with_departement as (
    select 
        sd.*,
        cd."LIBELLE" as nom_departement,
        cd."REG" as code_region
    from source_data sd
    left join codes_geographiques_departements cd on sd.code_departement = cd."DEP"
),

joined_with_region as (
    select 
        jd.*,
        cr."LIBELLE" as nom_region
    from joined_with_departement jd
    left join codes_geographiques_regions cr on jd.code_region = cr."REG"
)

select *
from joined_with_region