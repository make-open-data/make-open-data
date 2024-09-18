--- depends_on: {{ ref('logement_2020_valeurs') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{{ config(materialized='table') }}




{% set colonnes_a_aggreger_liste = lister_colonnes_par_theme('habitat') %}

{% set colonnes_cles_liste = lister_colonnes_par_theme('CLE') %}


with communes as (
    SELECT 
      "COMMUNE" as code_commune_insee,
      CAST( SUM(CAST("IPONDL" AS numeric)) AS INT) AS nombre_de_logements
    FROM 
      {{ source('sources', 'logement_2020')}}
    GROUP BY
      code_commune_insee
  ),
  aggregated as (

    SELECT * 

    FROM communes

    {% for colonne_a_aggreger in colonnes_a_aggreger_liste %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne(colonnes_a_aggreger_liste, colonnes_cles_liste, colonne_a_aggreger, "COMMUNE", "code_commune_insee") }} )
      USING (code_commune_insee)

    {% endfor %}

  )

SELECT 
    *  
FROM
    aggregated