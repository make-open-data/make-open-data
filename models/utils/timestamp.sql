{{ config(materialized='table') }}
select current_timestamp as generated_at