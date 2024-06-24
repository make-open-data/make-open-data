{% macro unpivot_logement(variante_logement, colonnes_a_aggreger_list, colonne_a_aggreger) %}  

-- Prends toutes les colonnes sauf la colonne à considérer, pour donne en paramètre à unpivot
  {% set colonnes_a_ignorer = ['region_residence'] %}
  {% for row in colonnes_a_aggreger_list %}
    {% if row != colonne_a_aggreger %}
      {% do colonnes_a_ignorer.append(row) %}
    {% endif %}
  {% endfor %}

    {{ dbt_utils.unpivot(
        relation=ref(variante_logement),
        exclude=['code_commune_insee', 'poids_du_logement'],
        remove=colonnes_a_ignorer,
        field_name='champs',
        value_name='valeur'
    ) }}
{% endmacro %}