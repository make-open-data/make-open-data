{% macro filtrer_dvf(source_dvf) %}
    SELECT 
        id_mutation,
        valeur_fonciere,
        longitude,
        latitude,
        nombre_pieces_principales,
        surface_reelle_bati,
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