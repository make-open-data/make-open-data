{% macro bien_dvf(filtrer_dvf) %}
    SELECT *
    FROM (
        SELECT 
            *,
            ROW_NUMBER() OVER (
                PARTITION BY id_mutation
                ORDER BY 
                    CASE WHEN type_local = 'Maison' THEN 1
                         WHEN type_local = 'Appartement' THEN 2
                         ELSE 3
                    END,
                    surface_reelle_bati DESC
            ) AS rang
        FROM 
            filtrer_dvf
    ) subquery
    WHERE
        rang = 1
{% endmacro %}