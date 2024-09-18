{% macro lister_colonne_a_aggrger_valeurs(colonne_a_aggreger) %}    


      {% set colonne_a_aggreger_values_query %}
        SELECT DISTINCT "COD_MOD"
        FROM {{ ref('logement_2020_valeurs') }}
        WHERE (theme != 'IGNORE') AND ("COD_VAR" = '{{ colonne_a_aggreger }}' )
      {% endset %}

      {% set colonne_a_aggreger_values = run_query(colonne_a_aggreger_values_query) %}


      {% set colonne_a_aggreger_values_list = [] %}
      {% for row in colonne_a_aggreger_values %}
          {% do colonne_a_aggreger_values_list.append(colonne_a_aggreger +"__"+ row[0]) %}
      {% endfor %}


      {{ return(colonne_a_aggreger_values_list) }}
{% endmacro %}