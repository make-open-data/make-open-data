{% macro filtrer_dvf(source_dvf) %}
    SELECT 
        id_mutation,
        CAST(valeur_fonciere AS FLOAT) as valeur_fonciere,
        CAST(longitude AS FLOAT) as longitude,
        CAST(latitude AS FLOAT) as latitude,
        CAST(nombre_pieces_principales AS NUMERIC) as nombre_pieces_principales,
        CAST(surface_reelle_bati AS NUMERIC) as surface_reelle_bati,
        type_local,
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        code_commune
    FROM 
        source_dvf 
     WHERE 
        EXISTS (
            SELECT 1
            FROM source_dvf d1
            WHERE d1.id_mutation = source_dvf.id_mutation AND d1.type_local IN ('Appartement', 'Maison')
        ) AND
        NOT EXISTS (
            SELECT 1
            FROM source_dvf d2
            WHERE d2.id_mutation = source_dvf.id_mutation AND d2.nature_mutation != 'Vente'
        )
{% endmacro %}