{{ config(materialized='view') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{% set colonnes_a_aggreger_list = lister_colonnes_a_aggreger('logement_2020_habitat_codes') %}


with communes as (
    SELECT 
      code_commune_insee,
      CAST( SUM(CAST(poids_du_logement AS numeric)) AS INT) AS nombre_de_logements
    FROM 
      {{ ref('decoder_habitat_communes') }}
    GROUP BY
      code_commune_insee
  ),
  aggregated as (

    SELECT * 

    FROM communes

    {% for colonne_a_aggreger in colonnes_a_aggreger_list %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne('decoder_habitat_communes', colonnes_a_aggreger_list, colonne_a_aggreger) }} )
      USING (code_commune_insee)

    {% endfor %}

  ),
  aggregated_with_cog as (
    SELECT
      *
    FROM
      aggregated
    JOIN
	    {{ ref('geo_communes') }} as cog
    ON
      aggregated.code_commune_insee = cog.code_commune
  )

SELECT 
    *  
FROM
    aggregated_with_cog