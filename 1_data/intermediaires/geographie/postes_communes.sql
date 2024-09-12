{{ 
    config(
        materialized='view',
        schema='intermediaires'
    ) 
}}

with unique_codes_communes_postaux as (
    select DISTINCT
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        code_commune_insee
    from {{ source('sources', 'cog_poste')}} as cog_poste
)

select *
from unique_codes_communes_postaux