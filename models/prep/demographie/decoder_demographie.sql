{{ config(materialized='view') }}

WITH logement AS (
    select * from {{ source('sources', 'logement_2020')}}
    where "REGION" = '76'
),
decode_logement AS (
    {{ renommer_colonnes_valeurs_logement(logement, 'logement_2020_demographie_codes') }}
)

SELECT 
    *
FROM 
    decode_logement