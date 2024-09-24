{{ 
    config(
        materialized='view',
        schema='intermediaires'
    ) 
}}

WITH logement AS (
    select * from {{ source('sources', 'logement_2020')}}
),
logement_renomee AS (
    ( {{ renommer_colonnes_values_logement(logement, 'habitat') }} )
)

SELECT 
    *
FROM 
    logement_renomee