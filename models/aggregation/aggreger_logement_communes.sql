{{
    config(
        materialized='view'
    )
}}

with pivoted as (
    select
        code_commune_insee,
        {{ dbt_utils.pivot(
            'champs__valeur',
            dbt_utils.get_column_values(ref('eclater_logement_communes'), 'champs__valeur'),
            agg='sum',
            then_value='population_par_commune_champs_valeur',
        ) }}
    from 
        {{ ref('eclater_logement_communes') }}
    group by
        code_commune_insee
)

SELECT 
    * 
FROM
    pivoted