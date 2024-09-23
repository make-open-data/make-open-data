-- A factoriser avec colonnes theme
{% macro lister_toutes_colonnes(theme) %}  


{% set colonnes_logement_query %}

  SELECT DISTINCT 
  "COD_VAR"
  FROM {{ ref('logement_2020_valeurs') }}
  WHERE (theme != 'CLE')

{% endset %}

{% set colonnes_logement_resultat = run_query(colonnes_logement_query) %}


{% set colonnes_a_aggreger_list = [] %}
{% for row in colonnes_logement_resultat %}
    {% do colonnes_a_aggreger_list.append(row[0]) %}
{% endfor %}


  
{{ return(colonnes_a_aggreger_list) }}


{% endmacro %}