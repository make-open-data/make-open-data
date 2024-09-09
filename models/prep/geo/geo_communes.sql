{{ config(materialized='table') }}

with filtre_cog_communes as (
    -- Filter out non-commune rows here to avoid confusion of filtering in the main query
    select * 
    from {{ source('sources', 'cog_communes')}} as cog_communes     
    where cog_communes.type in ('commune-actuelle', 'arrondissement-municipal')

),denomalise_cog as (
    select
        LPAD(CAST(filtre_cog_communes.code as TEXT), 5, '0') as code_commune,
        filtre_cog_communes.nom as nom_commune,
        filtre_cog_communes.arrondissement as code_arrondissement,
        filtre_cog_communes.departement as code_departement,
        filtre_cog_communes.region as code_region,
        "codesPostaux" as codes_postaux,
        filtre_cog_communes.population as population,
        filtre_cog_communes.zone as code_zone,
        
        cog_arrondissements.nom as nom_arrondissement,
        cog_departements.nom as nom_departement,
        cog_regions.nom as nom_region

    from filtre_cog_communes
    left join {{ source('sources', 'cog_arrondissements')}}  cog_arrondissements on cog_arrondissements.code = filtre_cog_communes.arrondissement
    left join {{ source('sources', 'cog_departements')}}  cog_departements on cog_departements.code = filtre_cog_communes.departement
    left join {{ source('sources', 'cog_regions')}}  cog_regions on cog_regions.code = filtre_cog_communes.region  
    
), geopoints as (
    select DISTINCT
        LPAD(CAST(cog_poste.code_commune_insee AS TEXT), 5, '0') as code_commune,
        CASE 
            WHEN SPLIT_PART(cog_poste._geopoint, ',', 1) = '' THEN NULL
            ELSE CAST(SPLIT_PART(cog_poste._geopoint, ',', 1) AS FLOAT)
        END AS commune_latitude,
        CASE 
            WHEN SPLIT_PART(cog_poste._geopoint, ',', 2) = '' THEN NULL
            ELSE CAST(SPLIT_PART(cog_poste._geopoint, ',', 2) AS FLOAT)
        END AS commune_longitude
    from {{ source('sources', 'cog_poste')}}  as cog_poste
)

select
    denomalise_cog.*,
    geopoints.commune_latitude,
    geopoints.commune_longitude
from denomalise_cog
left join geopoints on denomalise_cog.code_commune = geopoints.code_commune