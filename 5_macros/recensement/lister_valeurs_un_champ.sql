{% macro lister_champs_valeurs_libelle(colonne_a_aggreger) %}    


      {% set colonne_a_aggreger_values_query %}
        SELECT DISTINCT "COD_MOD", libelle_a_afficher_apres_aggregation
        FROM {{ ref('logement_2020_valeurs') }}
        WHERE (theme != 'IGNORE') AND ("COD_VAR" = '{{ colonne_a_aggreger }}' )
      {% endset %}

      {% set colonne_a_aggreger_values = run_query(colonne_a_aggreger_values_query) %}


      {% set champs_valeurs_liste = [] %}
      {% set libelle_liste  = [] %}
      {% for row in colonne_a_aggreger_values %}
          {% do champs_valeurs_liste.append(colonne_a_aggreger +"_"+ row[0]) %}
          {% do libelle_liste.append(row[1]) %}
      {% endfor %}


      {{ return([champs_valeurs_liste, libelle_liste]) }}
{% endmacro %}