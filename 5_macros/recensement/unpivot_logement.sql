  {% macro unpivot_logement(table_renomee, colonnes_a_aggreger_liste, colonnes_cles_liste, colonne_a_aggreger) %}  


-- Prends toutes les colonnes sauf la colonne à considérer, pour donne en paramètre à unpivot
  {% set colonnes_a_ignorer = [] %}

  {% for row in colonnes_a_aggreger_liste %}
    {% if row != colonne_a_aggreger %}
      {% do colonnes_a_ignorer.append(row) %}
    {% endif %}
  {% endfor %}

  {{ dbt_utils.unpivot(
      relation=ref(table_renomee),
      exclude=colonnes_cles_liste,
      remove=colonnes_a_ignorer,
      field_name='champs',
      value_name='valeur',
      quote_identifiers=True) }}


{% endmacro %}