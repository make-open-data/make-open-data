-- Macro pour calculer les k plus proches voisins (knn) pour chaque ligne d'une table
-- Proximité au sens géographique (distance haversine) et moyenne des valeurs

{% macro calculate_geo_knn(source_table, id_column, geopoint_column, value_column, k) %}
WITH knn AS (
    SELECT 
        a.{{ id_column }} AS id,
        AVG(b.{{ value_column }}) AS prix_m2_knn_{{ k }}
    FROM 
        {{ ref(source_table) }} a
        JOIN LATERAL (
            SELECT {{ value_column }}
            FROM {{ ref(source_table) }}
            WHERE ({{ id_column }} != a.{{ id_column }})
            ORDER BY ST_Distance(a.{{ geopoint_column }}, {{ geopoint_column }})
            LIMIT {{ k }}
        ) b ON TRUE
    GROUP BY a.{{ id_column }}
)

SELECT * FROM knn


{% endmacro %}