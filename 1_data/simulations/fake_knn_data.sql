-- Pour tester la fonction knn, nous devons créer une table avec des données fictives 
-- (impossible de faire des tests unitaires sur des données qui ne sont pas dans une table). 
-- crée une fausse table avec id, latitude, longitude, et valeur columns
-- S'assurer que le calcul ne se fait pas sur l'objet de la table

{{ 
    config(
        materialized='view',
        schema='simulations'
    ) 
}}
WITH fake_knn_table AS (
    SELECT 1 AS id, ST_SetSRID(ST_MakePoint(43.7, 3.832), 4326) AS geopoint, 100 AS valeur, '2024' AS millesime UNION ALL -- (3, 2) --> (200 + 300) / 2 = 250
    SELECT 3,       ST_SetSRID(ST_MakePoint(43.7, 3.830), 4326),             200,           '2024'              UNION ALL -- (1, 2) --> (100 + 300) / 2 = 200
    SELECT 2,       ST_SetSRID(ST_MakePoint(43.7, 3.831), 4326),             300,           '2024'              UNION ALL -- (1, 3) --> (100 + 200) / 2 = 150
    SELECT 4,       ST_SetSRID(ST_MakePoint(43.7, 3.839), 4326),             400,           '2024'              UNION ALL -- (6, 1) --> (500 + 100) / 2 = 300
    SELECT 6,       ST_SetSRID(ST_MakePoint(43.7, 3.838), 4326),             500,           '2024'                        -- (4, 1) --> (400 + 100) / 2 = 250
)


select * from fake_knn_table