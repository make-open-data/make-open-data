
/*
    Fournit une tables des communes avec les informations dénormalisées
*/

{{ config(materialized='table') }}

with filtre_cog_communes as (
    -- Filter out non-commune rows here to avoid confusion of filtering in the main query
    select * 
    from sources.cog_communes     
    where sources.cog_communes.type = 'commune-actuelle' 

),denomalise_cog as (
    select
        filtre_cog_communes.code as code_commune,
        filtre_cog_communes.nom as nom_commune,
        filtre_cog_communes.arrondissement as code_arrondissement,
        filtre_cog_communes.departement as code_departement,
        filtre_cog_communes.region as code_region,
        filtre_cog_communes."codesPostaux" as codes_postaux,
        filtre_cog_communes.population as population,
        filtre_cog_communes.zone as code_zone,
        
        sources.cog_arrondissements.nom as nom_arrondissement,
        sources.cog_departements.nom as nom_departement,
        sources.cog_regions.nom as nom_region

    from filtre_cog_communes
    left join sources.cog_arrondissements on sources.cog_arrondissements.code = filtre_cog_communes.arrondissement
    left join sources.cog_departements on sources.cog_departements.code = filtre_cog_communes.departement
    left join sources.cog_regions on sources.cog_regions.code = filtre_cog_communes.region  
    
), geopoints as (
    select DISTINCT
        LPAD(CAST(sources.cog_poste.code_commune_insee AS TEXT), 5, '0') as code_commune,
        CAST(SPLIT_PART(sources.cog_poste._geopoint, ',', 1) AS FLOAT) as commune_latitude,
        CAST(SPLIT_PART(sources.cog_poste._geopoint, ',', 2) AS FLOAT) as commune_longitude
    from sources.cog_poste
)

select
    denomalise_cog.*,
    geopoints.commune_latitude,
    geopoints.commune_longitude
from denomalise_cog
left join geopoints on denomalise_cog.code_commune = geopoints.code_commune