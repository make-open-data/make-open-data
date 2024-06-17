{% macro unpivot_logement() %}    
    {{ dbt_utils.unpivot(
        relation=ref('libelle_colonnes_logement'),
        exclude=['code_commune_insee', 'poids_du_logement'],
        field_name='champs',
        value_name='valeur'
    ) }}
{% endmacro %}