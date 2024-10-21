{% macro selectionner_bien_principal(ventes_immobiliers_filtrees) %}
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
            ventes_immobiliers_filtrees
    ) subquery
    WHERE
        rang = 1
{% endmacro %}