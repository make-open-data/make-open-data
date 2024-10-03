{% macro generate_dvf_for_millesime(millesime) %}
{{
    config(
        materialized='table',
        schema='intermediaires',
        alias='dvf_' ~ millesime,
        post_hook=[
            "CREATE INDEX IF NOT EXISTS geopoint_index_" ~ millesime ~ " ON {{ this }} USING GIST(geopoint)"
        ]
    )
}}

WITH source_dvf AS (
    select * from
    {% if target.name == 'production' %}
        {{ source('sources', 'dvf_' ~ millesime) }}
    {% else %}
        {{ source('sources', 'dvf_' ~ millesime ~ '_dev') }}
    {% endif %}
),
filtrer_dvf AS (
    {{ filtrer_dvf(source_dvf) }}
),
aggreger_dvf AS (
    {{ aggreger_dvf(filtrer_dvf) }}
),
bien_principal_dvf AS (
    {{ selectionner_bien_principal_dvf(filtrer_dvf) }}
)
SELECT
    bien_principal_dvf.id_mutation,
    bien_principal_dvf.valeur_fonciere,
    bien_principal_dvf.nature_mutation,
    bien_principal_dvf.longitude,
    bien_principal_dvf.latitude,
    aggreger_dvf.total_pieces,
    aggreger_dvf.total_surface_bati,
    aggreger_dvf.total_surface_terrain,
    aggreger_dvf.type_locaux,
    aggreger_dvf.id_parcelles,
    coalesce(bien_principal_dvf.type_local, 'Inconnu') as type_local,
    bien_principal_dvf.valeur_fonciere / aggreger_dvf.total_surface_bati as prix_m2,
    bien_principal_dvf.valeur_fonciere / bien_principal_dvf.surface_reelle_bati as prix_m2_bien_principal,
    ST_SetSRID(ST_MakePoint(bien_principal_dvf.latitude, bien_principal_dvf.longitude), 4326) as geopoint,
    bien_principal_dvf.code_postal,
    bien_principal_dvf.code_commune,
    infos_communes.nom_commune,
    infos_communes.code_arrondissement,
    infos_communes.code_departement,
    infos_communes.code_region,
    infos_communes.nom_arrondissement,
    infos_communes.nom_departement,
    infos_communes.nom_region
FROM
    bien_principal_dvf
JOIN
    aggreger_dvf ON aggreger_dvf.id_mutation = bien_principal_dvf.id_mutation
LEFT JOIN
    {{ ref('infos_communes') }} as infos_communes on infos_communes.code_commune = bien_principal_dvf.code_commune
{% endmacro %}

{% macro knn_with_mutations_foncieres(table_name) %}
    {{
        config(
            materialized='incremental',
            schema='prepare',
            alias='mutations_foncieres_enrichies_' ~ table_name
        )
    }}

    WITH dvf_knn_5 AS (
        {{ calculate_geo_knn(table_name, 'id_mutation', 'geopoint', 'prix_m2' , 5) }}
    )

    SELECT
        {{ table_name }}.*,
        dvf_knn_5.prix_m2_knn_5
    FROM
        {{ ref(table_name) }} {{ table_name }}
    LEFT JOIN
        dvf_knn_5 ON dvf_knn_5.id = {{ table_name }}.id_mutation
{% endmacro %}