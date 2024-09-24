--- depends_on: {{ ref('logement_2020_valeurs') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{{ config(materialized='table') }}


with aggregated as (
  {{ aggreger_colonnes_theme_geo('habitat', 'habitat_renomee', 'code_iris')}}
)

SELECT 
    *  
FROM
    aggregated