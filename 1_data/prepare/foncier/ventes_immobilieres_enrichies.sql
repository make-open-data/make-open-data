-- Enrichie la base dvf groupée par mutation
-- Ajoute le knn des prix au m2

{{ 
    config(
        materialized='table',
    ) 
}}

select * from {{ ref('ventes_immobilieres') }}
