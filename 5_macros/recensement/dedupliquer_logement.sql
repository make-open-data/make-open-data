{% macro dedupliquer_logement(concatenated, champs_geo) %}    
    SELECT
        {{ champs_geo }},
        champs,
        champs__valeur,
        CAST(SUM(CAST(poids_du_logement as NUMERIC)) AS INT) as population_par_champs_valeur
    FROM
        concatenated
    GROUP BY
        {{ champs_geo }},
        champs__valeur,
        champs
{% endmacro %}