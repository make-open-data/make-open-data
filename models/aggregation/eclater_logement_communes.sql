{{ config(materialized='view') }}


WITH unpivoted AS (
    {{ unpivot_logement()}}
),
concatenated as (
    {{ concatener_logement(unpivoted)}}
),
deduplicated as (
    {{ dedupliquer_logement(concatenated)}}
)
SELECT * FROM deduplicated