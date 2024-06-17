{{ config(materialized='table') }}

with aggregated as (
    {{ pivoter_logement() }}
)

SELECT 
    * 
FROM
    aggregated