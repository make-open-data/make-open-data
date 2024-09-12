{{ config(materialized='table') }}

WITH coordonnee_moyenne_par_code_postal AS (
    SELECT 
        cog_poste.code_postal as code_postal,
        AVG(infos_communes.commune_latitude) AS avg_lat,
        AVG(infos_communes.commune_longitude) AS avg_lon
    FROM {{ source('sources', 'cog_poste')}} cog_poste
    LEFT JOIN {{ ref('infos_communes')}} infos_communes 
    ON infos_communes.code_commune = cog_poste.code_commune_insee
    GROUP BY cog_poste.code_postal
),
distinct_code_postal AS (
    SELECT DISTINCT 
        code_postal, 
        code_commune_insee
    FROM {{ source('sources', 'cog_poste')}}
),
cog_postal_et_distance_moyenne AS (
    SELECT 
        distinct_code_postal.*,
        coordonnee_moyenne_par_code_postal.avg_lat,
        coordonnee_moyenne_par_code_postal.avg_lon
    FROM distinct_code_postal
    LEFT JOIN coordonnee_moyenne_par_code_postal
    ON distinct_code_postal.code_postal = coordonnee_moyenne_par_code_postal.code_postal
),
code_postal_et_commune_et_distance AS (
    SELECT 
        cog_postal_et_distance_moyenne.*,
        infos_communes.*,
        SQRT(POWER(infos_communes.commune_latitude - cog_postal_et_distance_moyenne.avg_lat, 2) + POWER(infos_communes.commune_longitude - cog_postal_et_distance_moyenne.avg_lon, 2)) AS distance
    FROM cog_postal_et_distance_moyenne 
    LEFT JOIN {{ ref('infos_communes')}} infos_communes
    ON cog_postal_et_distance_moyenne.code_commune_insee = infos_communes.code_commune
),
code_postal_et_commune_et_rang_distance_centre AS (
    SELECT 
        *,
    ROW_NUMBER() OVER (PARTITION BY code_postal ORDER BY distance, population DESC) AS rang_distance_puis_population 
    FROM code_postal_et_commune_et_distance
),
code_postal_et_commune_centrale AS (
    SELECT 
        code_postal,
        code_commune as code_commune_centrale,
        nom_commune as nom_commune_centrale,
        code_departement,
        avg_lat as latitude_centrale_code_postal,
        avg_lon as longitude_centrale_code_postal
    FROM code_postal_et_commune_et_rang_distance_centre
    WHERE rang_distance_puis_population = 1
),
join_departements as (
    select 
        code_postal_et_commune_centrale.*,
        cog_departements.nom as nom_departement,
        cog_departements.region as code_region
    from code_postal_et_commune_centrale
    left join {{ source('sources', 'cog_departements')}} cog_departements 
    on code_postal_et_commune_centrale.code_departement = cog_departements.code
),

join_regions as (
    select 
        join_departements.*,
        cog_regions.nom as nom_region
    from join_departements
    left join {{ source('sources', 'cog_regions')}} cog_regions 
    on join_departements.code_region = cog_regions.code
)

select *
from join_regions