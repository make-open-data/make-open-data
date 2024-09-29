{{ config(materialized='table') }}

with filosofi_commune as (
    select * 
    from {{ source('sources', 'filosofi_commune_2021')}}

),
renamed_columns as (
    select
        "CODGEO" as code_commune_2024,
        nullif("NBMENFISC21", 's') as nombre_menages_fiscaux,
        nullif("NBPERSMENFISC21", 's') as nombre_personnes,
        nullif("MED21", 's') as mediane_niveau_vie_euro,
        nullif("PIMP21", 's') as part_menages_fiscaux_imposes_pourcentage,
        nullif("TP6021", 's') as taux_pauvrete_ensemble_pourcentage,
        nullif("TP60AGE121", 's') as taux_pauvrete_moins_30_ans_pourcentage,
        nullif("TP60AGE221", 's') as taux_pauvrete_30_39_ans_pourcentage,
        nullif("TP60AGE321", 's') as taux_pauvrete_40_49_ans_pourcentage,
        nullif("TP60AGE421", 's') as taux_pauvrete_50_59_ans_pourcentage,
        nullif("TP60AGE521", 's') as taux_pauvrete_60_74_ans_pourcentage,
        nullif("TP60AGE621", 's') as taux_pauvrete_75_ans_ou_plus_pourcentage,
        nullif("TP60TOL121", 's') as taux_pauvrete_proprietaires_pourcentage,
        nullif("TP60TOL221", 's') as taux_pauvrete_locataires_pourcentage,
        nullif("PACT21", 's') as part_revenus_activite_pourcentage,
        nullif("PTSA21", 's') as part_salaires_traitements_pourcentage,
        nullif("PCHO21", 's') as part_indemnites_chomage_pourcentage,
        nullif("PBEN21", 's') as part_revenus_activites_non_salariees_pourcentage,
        nullif("PPEN21", 's') as part_pensions,
        nullif("PPAT21", 's') as part_revenus_patrimoine_autres_revenus_pourcentage,
        nullif("PPSOC21", 's') as part_ensemble_prestations_sociales_pourcentage,
        nullif("PPFAM21", 's') as part_prestations_familiales_pourcentage,
        nullif("PPMINI21", 's') as part_minima_sociaux_pourcentage,
        nullif("PPLOGT21", 's') as part_prestations_logement_pourcentage,
        nullif("PIMPOT21", 's') as part_des_impots_pourcentage,
        nullif("D121", 's') as decile_1_niveau_vie_euro,
        nullif("D921", 's') as decile_9_niveau_vie_euro,
        nullif("RD21", 's') as rapport_interdecile_9_1
    from filosofi_commune
)

select * from renamed_columns