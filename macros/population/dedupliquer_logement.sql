{% macro dedupliquer_logement(unpivoted) %}    
    SELECT
        code_commune_insee,
        champs__valeur,
        SUM(CAST(poids_du_logement as NUMERIC)) as population_par_commune_champs_valeur
    FROM
        concatenated
    GROUP BY
        code_commune_insee,
        champs__valeur
{% endmacro %}