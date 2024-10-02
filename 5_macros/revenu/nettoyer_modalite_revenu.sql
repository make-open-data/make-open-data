{% macro nettoyer_modalite_revenu(nom_colonne) %}
        cast(nullif(nullif(nullif(nullif(replace("{{ nom_colonne }}", ',', '.'), 'ns'), 'so'), 's'), 'nd') as NUMERIC)
{% endmacro %}