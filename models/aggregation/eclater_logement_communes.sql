{{ config(materialized='view') }}


WITH unpivoted AS (
    {{ dbt_utils.unpivot(
        relation=ref('decoder_logement'),
        exclude=['code_commune_insee', 'poids_du_logement'],
        field_name='champs',
        value_name='valeur'
    ) }}
),
concatenated as (
    SELECT
        code_commune_insee,
        poids_du_logement,
        champs,
        valeur,
        champs || '__' || valeur AS champs__valeur
    FROM
        unpivoted

),
deduplicated as (
    SELECT
        code_commune_insee,
        champs__valeur,
        SUM(CAST(poids_du_logement as NUMERIC)) as population_par_commune_champs_valeur
    FROM
        concatenated
    GROUP BY
        code_commune_insee,
        champs__valeur

)
SELECT * FROM deduplicated