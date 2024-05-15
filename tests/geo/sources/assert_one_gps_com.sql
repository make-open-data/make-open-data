-- https://www.data.gouv.fr/fr/datasets/base-officielle-des-codes-postaux/
-- Mention que : contient en plus les coordonnées des centroïdes des communes est également disponible.
-- Vérifions que les coordonnées des centroïdes sont bien uniques pour chaque commune

{{ config(materialized='test') }}

with source as (
    SELECT commune, COUNT(DISTINCT _geopoint) as geopoint_count
    FROM {{ ref('codes_postaux') }}
    GROUP BY commune
)

select *
from source
where geopoint_count > 1