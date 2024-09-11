{{ 
    config(
        materialized='view',
        schema='intermediaires'
    ) 
}}

WITH logement AS (
    select * from {{ source('sources', 'logement_2020')}}
),
decode_logement AS (
    {{ renommer_colonnes_valeurs_logement(logement, 'logement_2020_demographie_codes') }}
)

SELECT 
    *
FROM 
    decode_logement