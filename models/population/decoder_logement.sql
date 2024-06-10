
{{ config(materialized='view') }}

WITH logement AS (
    select * from sources.logement_2020
),
decode_logement AS (
    {{ renommer_colonnes_logement(logement) }}
)


SELECT 
    *
FROM 
    decode_logement
