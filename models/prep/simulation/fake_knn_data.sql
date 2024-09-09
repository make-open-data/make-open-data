-- Pour tester la fonction knn, nous devons créer une table avec des données fictives 
-- (impossible de faire des tests unitaires sur des données qui ne sont pas dans une table). 
-- crée une fausse table avec id, latitude, longitude, et valeur columns
-- S'assurer que le calcul ne se fait pas sur l'objet de la table

{{ config(materialized='table') }}

WITH fake_knn_table AS (
    SELECT 1 AS id, ST_Point(43.7, 3.832) AS geopoint, 100 AS valeur UNION ALL -- (3, 2) --> (200 + 300) / 2 = 250
    SELECT 3,       ST_Point(43.7, 3.830),             200 UNION ALL -- (1, 2) --> (100 + 300) / 2 = 200
    SELECT 2,       ST_Point(43.7, 3.831),             300 UNION ALL -- (1, 3) --> (100 + 200) / 2 = 150
    SELECT 4,       ST_Point(43.7, 3.839),             400 UNION ALL -- (6, 1) --> (500 + 100) / 2 = 300
    SELECT 6,       ST_Point(43.7, 3.838),             500  -- (4, 1) --> (400 + 100) / 2 = 250
)


select * from fake_knn_table