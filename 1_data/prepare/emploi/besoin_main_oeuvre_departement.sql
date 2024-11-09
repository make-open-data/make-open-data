{{ 
    config(
        materialized='table',
    ) 
}}

        -- metiers uniques

        {% set metiers_uniques_query %}
            SELECT DISTINCT "Famille_met"
            FROM {{ source('sources', 'bmo_2024') }}
        {% endset %}

        {% set metiers_uniques_result = run_query(metiers_uniques_query) %}

        {% set metiers_uniques_list = [] %}

        {% for row in metiers_uniques_result %}

            {% if row[0] not in metiers_uniques_list %}
                {% do metiers_uniques_list.append(row[0]) %}
            {% endif %}

        {% endfor %}


with renomer_bmo as (
    select 
        "Dept" as code_departement,
        "Code_métier_BMO" as code_metier,
        "Nom_métier_BMO" as nom_metier,
        "Famille_met" as code_famille_metier,
        "Lbl_fam_met" as libelle_famille_metier,
	    cast(nullif(met, '*') as numeric) as nb_projet_recrutement,
        cast(nullif(xmet, '*') as numeric) as nb_projet_recrutement_difficile,
        cast(nullif(smet, '*') as numeric) as nb_projet_recrutement_saisonnier
    from {{ source('sources', 'bmo_2024') }}
),
unpivot_bmo_recrutements as (
    select
        code_departement,
        {{ dbt_utils.pivot(
           'libelle_famille_metier',
            metiers_uniques_list,
           agg='sum',
           then_value='nb_projet_recrutement',
           prefix='besoins - '
        )}}
    from renomer_bmo
    group by code_departement
),
unpivot_bmo_recrutements_difficiles as (
    select
        code_departement,
        {{ dbt_utils.pivot(
           'libelle_famille_metier',
            metiers_uniques_list,
           agg='sum',
           then_value='nb_projet_recrutement_difficile',
           prefix='besoins difficiles - '
        )}}
    from renomer_bmo
    group by code_departement
),
unpivot_bmo_recrutements_saisonniers as (
    select
        code_departement,
        {{ dbt_utils.pivot(
           'libelle_famille_metier',
            metiers_uniques_list,
           agg='sum',
           then_value='nb_projet_recrutement_saisonnier',
           prefix='besoins saisonniers - '
        )}}
    from renomer_bmo
    group by code_departement
),
unpivot_tout_bmo as (
    select *
    from unpivot_bmo_recrutements
    natural left join unpivot_bmo_recrutements_saisonniers
    natural left join unpivot_bmo_recrutements_difficiles
    natural left join {{ ref('infos_departements') }}
)

select * from unpivot_tout_bmo
