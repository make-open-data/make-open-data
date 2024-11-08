--- Montre les communes qui ont plusieurs codes postaux

SELECT code_commune_insee, ARRAY_AGG(DISTINCT code_postal) as postal_codes
FROM {{ ref('cog_poste')}}
GROUP BY code_commune_insee
HAVING COUNT(DISTINCT code_postal) > 1
