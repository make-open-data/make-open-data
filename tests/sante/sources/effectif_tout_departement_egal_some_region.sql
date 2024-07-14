-- Teste que l'entrée 'Tout département' dans libelle de departement reporte le total des effectifs de tous les départements


WITH sommes_par_departement AS (
    SELECT 
        annee, 
        profession_sante, 
        libelle_region, 
        SUM(cast(effectif as numeric)) AS effectif_total_calcule
    FROM {{ source('sources', 'professionels_sante') }}
    WHERE libelle_departement != 'Tout departement'
    GROUP BY annee, profession_sante, libelle_region
),
	
tout_departement AS (
    SELECT 
        annee, 
        profession_sante, 
        libelle_region, 
        CAST(effectif as numeric) AS tout_departement_effectif
    FROM {{ source('sources', 'professionels_sante') }}
    WHERE libelle_departement = 'Tout departement'
)
	
SELECT 
    sommes_par_departement.effectif_total_calcule, 
    tout_departement.tout_departement_effectif
FROM sommes_par_departement
LEFT JOIN tout_departement 
    ON sommes_par_departement.annee = tout_departement.annee 
    AND sommes_par_departement.profession_sante = tout_departement.profession_sante 
    AND sommes_par_departement.libelle_region = tout_departement.libelle_region
WHERE sommes_par_departement.effectif_total_calcule != tout_departement.tout_departement_effectif