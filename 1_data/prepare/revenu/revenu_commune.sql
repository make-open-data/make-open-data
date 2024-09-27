{{ config(materialized='table') }}

with filosofi_commune as (
    select * 
    from {{ source('sources', 'filosofi_commune_2021')}}

)

select * from filosofi_commune