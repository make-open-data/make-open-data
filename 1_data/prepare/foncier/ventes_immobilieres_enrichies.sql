-- Enrichie la base dvf groupée par mutation
-- Ajoute le knn des prix au m2

{{ 
    config(
        materialized='table',
    ) 
}}

WITH dvf_knn_5 as(
    {{ calculate_geo_knn('ventes_immobilieres', 'id_mutation', 'geopoint', 'prix_m2' , 5) }}
)

select ventes_immobilieres.*, 
       dvf_knn_5.prix_m2_knn_5 
from {{ ref('ventes_immobilieres') }} ventes_immobilieres
left join dvf_knn_5 on dvf_knn_5.id = ventes_immobilieres.id_mutation

