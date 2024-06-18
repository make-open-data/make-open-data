  -- depends_on: {{ ref('logement_2020_codes') }}
  
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
WHERE
    region_residence = 'occitanie'