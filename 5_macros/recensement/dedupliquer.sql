{% macro dedupliquer_logement(concatenated, champs_geo_arrivee) %}    
    SELECT
        {{ champs_geo_arrivee }},
        champs,
        champs_valeur,
        CAST(SUM(CAST(poids_du_logement as NUMERIC)) AS INT) as population_par_champs_valeur
    FROM
        concatenated
    GROUP BY
        {{ champs_geo_arrivee }},
        champs_valeur,
        champs
{% endmacro %}