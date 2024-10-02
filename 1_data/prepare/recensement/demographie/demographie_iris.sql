--- depends_on: {{ ref('logement_2020_valeurs') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{{ config(materialized='table') }}

with aggregated as (
  {{ aggreger_colonnes_theme_geo('demographie', 'demographie_renomee', 'code_iris')}}
), 
aggregated_with_infos_iris as (
    SELECT
      *
    FROM
      aggregated
    LEFT JOIN
	    {{ ref('infos_iris') }} as infos_iris
    ON
      aggregated.code_iris = infos_iris.code_iris_2024
  )

SELECT 
    *  
FROM
    aggregated_with_infos_iris