-- https://www.data.gouv.fr/fr/datasets/base-officielle-des-codes-postaux/
-- Mention que : contient en plus les coordonnées des centroïdes des communes est également disponible.
-- Vérifions que les coordonnées des centroïdes sont bien uniques pour chaque commune

{{ config(materialized='test') }}

with source as (
    SELECT code_commune_insee, COUNT(DISTINCT _geopoint) as geopoint_count
    FROM {{ ref('cog_poste')}} as cog_poste
    GROUP BY code_commune_insee
)

select *
from source
where geopoint_count > 1
