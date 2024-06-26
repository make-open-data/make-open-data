{{ config(materialized='table') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{% set colonnes_a_aggreger_list = lister_colonnes_a_aggreger('logement_2020_habitat_codes') %}


with communes as (
    SELECT 
      code_commune_insee,
      SUM(CAST(poids_du_logement AS numeric)) AS nombre_de_logements
    FROM 
      {{ ref('decoder_habitat') }}
    GROUP BY
      code_commune_insee
  ),
  aggregated as (

    SELECT * 

    FROM communes

    {% for colonne_a_aggreger in colonnes_a_aggreger_list %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne('decoder_habitat', colonnes_a_aggreger_list, colonne_a_aggreger) }} )
      USING (code_commune_insee)

    {% endfor %}

  )

SELECT 
    *  
FROM
    aggregated