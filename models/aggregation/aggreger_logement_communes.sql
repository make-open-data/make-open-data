{{ config(materialized='table') }}


{% set colonnes_a_aggreger_list = lister_colonnes_a_aggreger() %}

{{ print(colonnes_a_aggreger_list) }}



with communes as (
    SELECT DISTINCT code_commune_insee from {{ ref('libelle_colonnes_logement') }}
  ),
  aggregated as (

    SELECT * 

    FROM communes

    {% for colonne_a_aggreger in colonnes_a_aggreger_list %}

      {% set colonne_a_aggreger_values_list = lister_colonne_a_aggrger_valeurs(colonne_a_aggreger) %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne(colonnes_a_aggreger_list, loop.index, colonne_a_aggreger, colonne_a_aggreger_values_list) }} ) pivoter_logement_{{ loop.index }} 
      ON communes.code_commune_insee = pivoter_logement_{{ loop.index }}.code_commune_insee_{{ loop.index }} 

    {% endfor %}

  )

SELECT 
    *  
FROM
    aggregated