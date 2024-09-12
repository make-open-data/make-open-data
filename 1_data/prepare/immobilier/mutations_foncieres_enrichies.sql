-- Enrichie la base dvf groupée par mutation
-- Ajoute le knn des prix au m2

{{ 
    config(
        materialized='table',
    ) 
}}

WITH dvf_knn_5 as(
    {{ calculate_geo_knn('mutations_foncieres', 'id_mutation', 'geopoint', 'prix_m2' , 5) }}
)

select mutations_foncieres.*, 
       dvf_knn_5.prix_m2_knn_5 
from {{ ref('mutations_foncieres') }} mutations_foncieres
left join dvf_knn_5 on dvf_knn_5.id = mutations_foncieres.id_mutation

