{{
    config(
        materialized='table'
    )
}}

SELECT *
FROM read_csv('https://make-open-data-s3.fra1.digitaloceanspaces.com/cog_poste/base-officielle-codes-postaux.csv')
  AS (
    code_commune_insee text,
    nom_de_la_commune text,
    code_postal text,
    libelle_d_acheminement text,
    ligne_5 text,
    _geopoint text
  )
