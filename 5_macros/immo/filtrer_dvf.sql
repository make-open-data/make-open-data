{% macro filtrer_dvf(source_dvf) %}
    SELECT 
        id_mutation,
        CAST(valeur_fonciere AS FLOAT) as valeur_fonciere,
        CAST(longitude AS FLOAT) as longitude,
        CAST(latitude AS FLOAT) as latitude,
        CAST(nombre_pieces_principales AS NUMERIC) as nombre_pieces_principales,
        CAST(surface_reelle_bati AS NUMERIC) as surface_reelle_bati,
        COALESCE(type_local, CASE WHEN nature_culture IS NOT NULL THEN 'Terrain' ELSE NULL END) AS type_local,
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        code_commune,
        id_parcelle,
        nature_culture,
        surface_terrain,
        nature_mutation
    FROM
        source_dvf
    WHERE COALESCE(type_local, CASE WHEN nature_culture IS NOT NULL THEN 'Terrain' ELSE NULL END) is not null
{% endmacro %}