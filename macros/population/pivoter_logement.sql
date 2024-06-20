{% macro pivoter_logement(deduplicated, colonne_a_aggreger, colonne_index) %}    

  {% set colonne_a_aggreger_values_query %}
      SELECT DISTINCT 
      {{ colonne_a_aggreger }}
      FROM {{ ref("libelle_colonnes_logement" ) }}
  {% endset %}

  {% set colonne_a_aggreger_values = run_query(colonne_a_aggreger_values_query) %}

  {% set colonne_a_aggreger_values_list = [] %}
  {% for row in colonne_a_aggreger_values %}
      {% do colonne_a_aggreger_values_list.append(colonne_a_aggreger +"__"+ row[0]) %}
  {% endfor %}



    select 

    code_commune_insee as code_commune_insee_{{ colonne_index }},
    {{ dbt_utils.pivot(
        'champs__valeur',
        colonne_a_aggreger_values_list,
        agg='sum',
        then_value='population_par_commune_champs_valeur',
    ) }}
    from 
        deduplicated
    group by
        code_commune_insee

{% endmacro %}
