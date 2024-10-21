{% macro aggreger_ventes_immobiliers(ventes_immobiliers_filtrees) %}
    SELECT 
        id_mutation,
        SUM(CAST(surface_reelle_bati AS numeric)) AS total_surface,
        SUM(CAST(nombre_pieces_principales AS numeric)) AS total_pieces
    FROM 
        ventes_immobiliers_filtrees
    GROUP BY 
        id_mutation
{% endmacro %}