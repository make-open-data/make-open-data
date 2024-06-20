{% macro dedupliquer_logement(concatenated) %}    
    SELECT
        code_commune_insee,
        champs,
        champs__valeur,
        SUM(CAST(poids_du_logement as NUMERIC)) as population_par_commune_champs_valeur
    FROM
        concatenated
    GROUP BY
        code_commune_insee,
        champs__valeur,
        champs
{% endmacro %}