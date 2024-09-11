--- Le nombre officiel de communes est de 35029 soit
--- zone = metro & drom est de 34935 en 2024
--- i.e. france metropole et departement d'outre mer
--- https://www.collectivites-locales.gouv.fr/bulletin-dinformation-statistique-bis-de-la-dgcl
--- PLUS zone = com  est 94 
--- i.e. collectivité d'outre mer
--- Plus 45 communes municipales (Paris, Lyon, Marseille)

{{ config(materialized='test') }}

with source as (
    SELECT COUNT(DISTINCT code_commune) as commune_count
    FROM {{ ref('infos_communes') }}
)

select *
from source
where commune_count != 35074