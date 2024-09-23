--- depends_on: {{ ref('logement_2020_valeurs') }}

--- Agrège les données de la base logement par commune
--- Colonne par colonne pour ne pas saturer la mémoire
--- L'agrégration est faite par univot/pivot.

{{ config(materialized='table') }}



{% set toutes_colonnes_liste = lister_toutes_colonnes() %}

{% set colonnes_a_aggreger_liste = lister_colonnes_par_theme('mobilite') %}

{% set colonnes_cles_liste = lister_colonnes_par_theme('CLE') %}


with iris as (
    SELECT 
      "IRIS" as code_iris,
      CAST( SUM(CAST("IPONDL" AS numeric)) AS INT) AS nombre_de_logements
    FROM 
      {{ source('sources', 'logement_2020')}}
    GROUP BY
      code_iris
  ),
  aggregated as (

    SELECT * 

    FROM iris

    {% for colonne_a_aggreger in colonnes_a_aggreger_liste %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne(toutes_colonnes_liste, colonnes_cles_liste, colonne_a_aggreger, "IRIS", "code_iris") }}  )
      USING (code_iris)

    {% endfor %}

  )

SELECT 
    *  
FROM
    aggregated