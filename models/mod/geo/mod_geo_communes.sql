
/*
    Merge all data to commune level


    Try changing "table" to "view" below
*/

{{ config(materialized='table') }}

with filtered_codes_geographiques_communes as (
    -- Filter out non-commune rows here to avoid confusion of filtering in the main query
    select * 
    from codes_geographiques_communes     
    where codes_geographiques_communes."TYPECOM" = 'COM' 

), source_data as (

    select
        f_cgc."COM" as code_commune_insee,
        f_cgc."LIBELLE" as nom_commune,
        f_cgc."REG" as code_region,
        cgr."LIBELLE" as nom_region,
        f_cgc."DEP" as code_departement,
        cgd."LIBELLE" as nom_departement,
        f_cgc."ARR" as code_arrondissement,
        cga."LIBELLE" as nom_arrondissement
    from filtered_codes_geographiques_communes f_cgc 
    left join codes_geographiques_arrondissements cga on f_cgc."ARR" = cga."ARR" 
    left join codes_geographiques_departements cgd on f_cgc."DEP" = cgd."DEP" 
    left join codes_geographiques_regions cgr on f_cgc."REG" = cgr."REG"     
), geopoints as (
    select DISTINCT
        LPAD(CAST(cp.code_commune_insee AS TEXT), 5, '0') as code_commune_insee,
        CAST(SPLIT_PART(cp._geopoint, ',', 1) AS FLOAT) as commune_latitude,
        CAST(SPLIT_PART(cp._geopoint, ',', 2) AS FLOAT) as commune_longitude
    from codes_postaux cp
)

select
    sd.*,
    gp.commune_latitude,
    gp.commune_longitude
from source_data sd
left join geopoints gp on sd.code_commune_insee = gp.code_commune_insee