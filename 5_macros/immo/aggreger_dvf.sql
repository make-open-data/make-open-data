{% macro aggreger_dvf(filtrer_dvf) %}
    SELECT 
        id_mutation,
        SUM(CAST(surface_reelle_bati AS numeric)) AS total_surface_bati,
        SUM(CAST(surface_terrain AS numeric)) AS total_surface_terrain,
        SUM(CAST(nombre_pieces_principales AS numeric)) AS total_pieces,
        json_agg(DISTINCT COALESCE(COALESCE(type_local, CASE WHEN nature_culture IS NOT NULL THEN 'Terrain' ELSE NULL END), 'Inconnu')) AS type_locaux,
        json_agg(DISTINCT nature_culture) FILTER (WHERE nature_culture IS NOT NULL) AS nature_cultures,
        json_agg(DISTINCT id_parcelle) FILTER (WHERE id_parcelle IS NOT NULL) AS id_parcelles
    FROM
        filtrer_dvf
    GROUP BY 
        id_mutation
{% endmacro %}