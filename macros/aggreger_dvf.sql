{% macro aggreger_dvf(filtrer_dvf) %}
    SELECT 
        id_mutation,
        SUM(surface_reelle_bati) AS total_surface,
        SUM(nombre_pieces_principales) AS total_pieces
    FROM 
        filtrer_dvf
    GROUP BY 
        id_mutation
{% endmacro %}