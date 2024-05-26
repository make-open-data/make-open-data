{% macro aggreger_dvf(filtrer_dvf) %}
    SELECT 
        id_mutation,
        SUM(CAST(surface_reelle_bati AS numeric)) AS total_surface,
        SUM(CAST(nombre_pieces_principales AS numeric)) AS total_pieces
    FROM 
        filtrer_dvf
    GROUP BY 
        id_mutation
{% endmacro %}