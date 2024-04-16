-- assert_value_for_mutation.sql

WITH mutation_values AS (
    SELECT 
        id_mutation,
        code_commune,
        code_postal,
        latitude,
        longitude,
        valeur_fonciere
    FROM 
        dvf
),

mutation_value_counts AS (
    SELECT 
        id_mutation,
        COUNT(DISTINCT valeur_fonciere) AS distinct_fonciere_count
    FROM 
        mutation_values
    GROUP BY 
        id_mutation
)

SELECT 
    id_mutation,
    distinct_fonciere_count
FROM 
    mutation_value_counts
WHERE 
    distinct_fonciere_count > 1