--- depends_on: {{ ref('logement_2020_valeurs') }}
  -- depends_on: {{ ref('habitat_renomee') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{{ config(materialized='table') }}

with aggregated as (
  {{ aggreger_colonnes_theme_geo('habitat', 'habitat_renomee', 'code_commune_insee')}}
),
  aggregated_with_infos_communes as (
    SELECT
      *
    FROM
      aggregated
    LEFT JOIN
	    {{ ref('infos_communes') }} as infos_communes
    ON
      aggregated.code_commune_insee = infos_communes.code_commune
  )

SELECT 
    *  
FROM
    aggregated_with_infos_communes