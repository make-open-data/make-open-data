{{ config(materialized='table') }}

WITH seveso_sites AS (
    SELECT * FROM {{  source('sources', 'seveso_2024') }}
),
renamed_columns AS (
    SELECT
        longitude::numeric as longitude,
        latitude::numeric as latitude,
        ST_SETSRID(ST_MAKEPOINT(longitude::numeric, latitude::numeric), 4326) as point,
        identifier as id_site,
        name as nom_site,
        localid as id_national_incremental,
        streetname as nom_de_rue,
        postalcode as code_postal,
        city as ville,
        status as statut_exploitation,
        activity as type_activite,
        id_lex_aiot_seveso::integer as id_seuil,
        type as nom_seuil
    FROM seveso_sites
)
SELECT * FROM renamed_columns