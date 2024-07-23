-- Enrichie la base dvf groupée par mutation
-- Ajoute le knn des prix au m2

{{ 
    config(
        materialized='table',
    ) 
}}

WITH dvf_knn_5 as(
    {{ calculate_geo_knn('grouper_mutations', 'id_mutation', 'geopoint', 'prix_m2' , 5) }}
)

select grouper_mutations.*, 
       dvf_knn_5.prix_m2_knn_5 
from {{ ref('grouper_mutations') }} grouper_mutations
left join dvf_knn_5 on dvf_knn_5.id = grouper_mutations.id_mutation

