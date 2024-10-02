{{ config(materialized='table') }}

with infos_iris as (
    select 
        "CODE_IRIS" as code_iris_2024,
        "IRIS" as suffix_iris_2024,
        "NOM_IRIS" as nom_iris,
        "INSEE_COM" as code_commune_2024,
        geometry as contour_iris,
        CASE 
            WHEN "TYP_IRIS" = 'A' THEN 'zone_activite'
            WHEN "TYP_IRIS" = 'H' THEN 'zone_habitat'
            WHEN "TYP_IRIS" = 'D' THEN 'zone_divers'
            WHEN "TYP_IRIS" = 'Z' THEN 'zone_non_iris'
        END
        as type_iris,
        ST_PointOnSurface(geometry) as iris_centre_geopoint,
        ST_X(ST_TRANSFORM(ST_PointOnSurface(geometry), 4674)) AS iris_longitude,
        ST_Y(ST_TRANSFORM(ST_PointOnSurface(geometry), 4674)) AS iris_latitude
    from {{ source('sources', 'shape_iris_2024')}} as infos_iris

)

select 
    infos_iris.*,
    infos_communes.nom_commune,
    infos_communes.code_arrondissement,
    infos_communes.code_departement,
    infos_communes.code_region,
    infos_communes.nom_arrondissement,
    infos_communes.nom_departement,
    infos_communes.nom_region
from infos_iris as infos_iris
left join {{ ref('infos_communes') }} as infos_communes on infos_communes.code_commune = infos_iris.code_commune_2024

