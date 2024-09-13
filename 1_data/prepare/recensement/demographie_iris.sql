{{ config(materialized='view') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{% set colonnes_a_aggreger_list = lister_colonnes_a_aggreger('logement_2020_demographie_codes') %}


with iris as (
    SELECT 
      code_iris,
      CAST( SUM(CAST(poids_du_logement AS numeric)) AS INT) AS nombre_de_logements
    FROM 
      {{ ref('decoder_demographie') }}
    GROUP BY
      code_iris
  ),
  aggregated as (

    SELECT * 

    FROM iris

    {% for colonne_a_aggreger in colonnes_a_aggreger_list %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne('decoder_demographie', colonnes_a_aggreger_list, colonne_a_aggreger, 'code_iris') }} )
      USING (code_iris)

    {% endfor %}

  )
SELECT 
    *  
FROM
    aggregated