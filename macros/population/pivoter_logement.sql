{% macro pivoter_logement(colonne_a_aggreger, colonne_index) %}    

  {% set colonne_a_aggreger_values_query %}
    SELECT DISTINCT 
    champs__valeur
    FROM {{ ref('eclater_logement_communes') }} WHERE champs = '{{ colonne_a_aggreger }}'
  {% endset %}

  {% set colonne_a_aggreger_values = run_query(colonne_a_aggreger_values_query) %}

  {% set colonne_a_aggreger_values_list = [] %}
  {% for row in colonne_a_aggreger_values %}
      {% do colonne_a_aggreger_values_list.append(row[0]) %}
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
        {{ ref('eclater_logement_communes') }} WHERE champs = '{{ colonne_a_aggreger }}'
    group by
        code_commune_insee

{% endmacro %}
