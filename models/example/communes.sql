
/*
    Merge all data to commune level


    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with source_data as (

    select
        cgc."COM" as code_commune_insee,
        cgc."LIBELLE" as nom_commune,
        cgc."REG" as code_region,
        cgr."LIBELLE" as nom_region,
        cgc."DEP" as code_departement,
        cgd."LIBELLE" as nom_departement,
        cgc."ARR" as code_arrondissement,
        cga."LIBELLE" as nom_arrondissement,
        LPAD(CAST(cp.code_postal AS TEXT), 5, '0') as code_postal,
        CAST(SPLIT_PART(cp._geopoint, ',', 1) AS FLOAT) as commune_latitude,
        CAST(SPLIT_PART(cp._geopoint, ',', 2) AS FLOAT) as commune_longitude
    from codes_geographiques_communes cgc
    left join code_postaux cp on cgc."COM" = cp.code_commune_insee 
    left join codes_geographiques_arrondissements cga on cgc."ARR" = cga."ARR"
    left join codes_geographiques_departements cgd on cgc."DEP" = cgd."DEP"
    left join codes_geographiques_regions cgr on cgc."REG" = cgr."REG"

)

select *
from source_data