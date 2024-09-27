{{ config(materialized='table') }}

with filosofi_commune as (
    select * 
    from {{ source('sources', 'filosofi_commune_2021')}}

),
renamed_columns as (
    select
    "NBMENFISC21" as nombre_menages_fiscaux,
    "NBPERSMENFISC21" as nombre_personnes,
    "MED21" as mediane_niveau_vie_euro,
    "PIMP21" as part_menages_fiscaux_imposes_pourcentage,
    "TP6021" as taux_pauvrete_ensemble_pourcentage,
    "TP60AGE121" as taux_pauvrete_moins_30_ans_pourcentage,
    "TP60AGE221" as taux_pauvrete_30_39_ans_pourcentage,
    "TP60AGE321" as taux_pauvrete_40_49_ans_pourcentage,
    "TP60AGE421" as taux_pauvrete_50_59_ans_pourcentage,
    "TP60AGE521" as taux_pauvrete_60_74_ans_pourcentage,
    "TP60AGE621" as taux_pauvrete_75_ans_ou_plus_pourcentage,
    "TP60TOL121" as taux_pauvrete_proprietaires_pourcentage,
    "TP60TOL221" as taux_pauvrete_locataires_pourcentage,
    "PACT21" as part_revenus_activite_pourcentage,
    "PTSA21" as part_salaires_traitements_pourcentage,
    "PCHO21" as part_indemnites_chomage_pourcentage,
    "PBEN21" as part_revenus_activites_non_salariees_pourcentage,
    "PPEN21" as part_pensions,
    "PPAT21" as part_revenus_patrimoine_autres_revenus_pourcentage,
    "PPSOC21" as part_ensemble_prestations_sociales_pourcentage,
    "PPFAM21" as part_prestations_familiales_pourcentage,
    "PPMINI21" as part_minima_sociaux_pourcentage,
    "PPLOGT21" as part_prestations_logement_pourcentage,
    "PIMPOT21" as part_des_impots_pourcentage,
    "D121" as decile_1_niveau_vie_euro,
    "D921" as decile_9_niveau_vie_euro,
    "RD21" as rapport_interdecile_9_1,
    "CODGEO" as  code_geographique
    from filosofi_commune
)

select * from renamed_columns