{{ config(materialized='table') }}

SELECT 
    datatourisme_place."Nom_du_POI" as nom,
    (
        SELECT array_agg(
            distinct regexp_replace(unnest_part, '.+[\/#]', '', 'g')
        ) AS extracted_tags
        FROM unnest(
            regexp_split_to_array(
                datatourisme_place."Categories_de_POI",
                '\|'
            )
        ) AS unnest_part
    ) as categories,
    ST_SetSRID(
        ST_MakePoint(
            datatourisme_place."Longitude"::numeric,
            datatourisme_place."Latitude"::numeric
        ),
        4326
    ) as geopoint,
    datatourisme_place."Adresse_postale" as adresse_postale,
    (regexp_split_to_array(datatourisme_place."Code_postal_et_commune", '#')::VARCHAR[])[1] as code_postal,
    (regexp_split_to_array(datatourisme_place."Code_postal_et_commune", '#')::VARCHAR[])[2] as commune,
    infos_communes.code_commune,
    infos_communes.codes_postaux,
    infos_communes.nom_commune,
    -- "Covid19_mesures_specifiques" as covid19_mesures_specifiques,
    datatourisme_place."Createur_de_la_donnee" as createur_de_la_donnee,
    datatourisme_place."SIT_diffuseur" as sit_diffuseur,
    datatourisme_place."Date_de_mise_a_jour"::date as date_de_mise_a_jour,
    datatourisme_place."Contacts_du_POI" as contacts_du_poi,
    datatourisme_place."Classements_du_POI" as classements_du_poi,
    datatourisme_place."Description" as description
    -- "URI_ID_du_POI" as uri_id_du_poi,
FROM {{ source('sources', 'datatourisme_place') }} datatourisme_place
LEFT JOIN {{ ref('infos_communes')}} infos_communes ON ST_Contains(
    infos_communes.commune_contour,
    ST_Transform(
        ST_SetSRID(
            ST_MakePoint(
                datatourisme_place."Longitude"::numeric,
                datatourisme_place."Latitude"::numeric
            ),
            4326
        ),
        2154
    )
)