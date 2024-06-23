{{ config(materialized='view') }}

WITH logement AS (
    select * from {{ source('sources', 'logement_2020')}}
),
decode_logement AS (
    {{ renommer_colonnes_logement(logement) }}
)

SELECT 
    *
FROM 
    decode_logement