--- Le shapefile des départements semble corrompu

{{ config(materialized='table') }}

select 
    code_departement,
    nom_departement,
    code_region,
    nom_region,
    sum(cast(population as numeric)) as population_departement,
    ST_Union(commune_contour) AS contour_departement 
from {{ ref('infos_communes') }}
group by code_departement, nom_departement, code_region, nom_region
