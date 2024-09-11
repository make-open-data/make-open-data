{% macro concatener_logement(unpivoted) %}    
    SELECT
        code_commune_insee,
        poids_du_logement,
        champs,
        valeur,
        champs || '__' || valeur AS champs__valeur
    FROM
        unpivoted
{% endmacro %}