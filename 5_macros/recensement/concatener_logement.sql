{% macro concatener_logement(unpivoted, champs_geo) %}    
    SELECT
        {{ champs_geo }},
        poids_du_logement,
        champs,
        valeur,
        champs || '__' || valeur AS champs__valeur
    FROM
        unpivoted
{% endmacro %}