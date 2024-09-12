-- Dans le fichier source de dvf, les mutations apparaissent sur plusieurs ligne
-- Il s'agit des transactions multiventes (un appartement dans une ligne et une maison dans une autre)
-- Il s'agit donc de vérifier que chaque mutation, donc dans les lignes où elle apparait, il n'a qu'une seule valeur foncière

WITH mutation_values AS (
    SELECT 
        id_mutation,
        code_commune,
        code_postal,
        latitude,
        longitude,
        valeur_fonciere
    FROM 
        {{ source('sources', 'dvf_2023')}} as dvf_2023
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