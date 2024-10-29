--- depends_on: {{ ref('logement_2020_valeurs') }}

{{ config(materialized='table') }}


select recensement_theme_departement.* ,
       infos_departements.nom_departement,
       infos_departements.code_region,
       infos_departements.nom_region,
       infos_departements.population_departement,
       infos_departements.contour_departement 
from ({{ aggreger_supra_commune('activite', 'code_departement') }}) recensement_theme_departement
left join {{ ref('infos_departements') }} infos_departements 
using (code_departement)
