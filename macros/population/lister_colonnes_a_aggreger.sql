{% macro lister_colonnes_a_aggreger(variante_logement) %}    


{% set colonnes_logement_query %}

  SELECT DISTINCT 
  lib_col
  FROM {{ ref(variante_logement) }}
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
  
  {{ return(colonnes_a_aggreger_list) }}

{% endif %}


{% endmacro %}