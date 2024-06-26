--- Montre les codes postaux qui ont plusieurs codes communes

SELECT code_postal, ARRAY_AGG(DISTINCT code_commune_insee) as communes
FROM {{ source('sources', 'cog_poste')}} 
GROUP BY code_postal
HAVING COUNT(DISTINCT code_commune_insee) > 1
