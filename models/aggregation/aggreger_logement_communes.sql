  -- depends_on: {{ ref('eclater_logement_communes') }}
  
{{ config(materialized='table') }}

{% set colonnes_logement_query %}
  SELECT DISTINCT 
  lib_col
  FROM {{ ref('logement_2020_codes') }}
{% endset %}
{% set colonnes_logement_resultat = run_query(colonnes_logement_query) %}

{% set colonnes_cles = ['code_commune_insee', 'poids_du_logement', 'region_residence'] %}
{% if execute %}
  {% set colonnes_a_aggreger_list = [] %}
  {% for row in colonnes_logement_resultat %}
    {% if row[0] not in colonnes_cles %}
      {% do colonnes_a_aggreger_list.append(row[0]) %}
    {% endif %}
  {% endfor %}
{% endif %}


with communes as (
    SELECT DISTINCT code_commune_insee from {{ ref('libelle_colonnes_logement') }}
  ),
  aggregated as (

     SELECT * 
     FROM communes

      {% for colonne_a_aggreger in colonnes_a_aggreger_list %}
      
        LEFT JOIN ( {{ pivoter_logement(colonne_a_aggreger, loop.index) }}) pivoter_logement_{{ loop.index }} 
        ON communes.code_commune_insee = pivoter_logement_{{ loop.index }}.code_commune_insee_{{ loop.index }} 
      
      {% endfor %}
  )


SELECT 
    *  
FROM
    aggregated