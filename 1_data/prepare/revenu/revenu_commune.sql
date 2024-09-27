{{ config(materialized='table') }}

with filosofi_commune as (
    select * 
    from {{ source('sources', 'filosofi_commune_2021')}}

),
renamed_columns as (
    select
        "CODGEO" as code_geographique,
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
        "RD21" as rapport_interdecile_9_1
    from filosofi_commune
),
fix_null_text_data as (
    select
        nullif(code_geographique, 's') as code_geographique,
        nullif(nombre_menages_fiscaux, 's') as nombre_menages_fiscaux,
        nullif(nombre_personnes, 's') as nombre_personnes,
        nullif(mediane_niveau_vie_euro, 's') as mediane_niveau_vie_euro,
        nullif(part_menages_fiscaux_imposes_pourcentage, 's') as part_menages_fiscaux_imposes_pourcentage,
        nullif(taux_pauvrete_ensemble_pourcentage, 's') as taux_pauvrete_ensemble_pourcentage,
        nullif(taux_pauvrete_moins_30_ans_pourcentage, 's') as taux_pauvrete_moins_30_ans_pourcentage,
        nullif(taux_pauvrete_30_39_ans_pourcentage, 's') as taux_pauvrete_30_39_ans_pourcentage,
        nullif(taux_pauvrete_40_49_ans_pourcentage, 's') as taux_pauvrete_40_49_ans_pourcentage,
        nullif(taux_pauvrete_50_59_ans_pourcentage, 's') as taux_pauvrete_50_59_ans_pourcentage,
        nullif(taux_pauvrete_60_74_ans_pourcentage, 's') as taux_pauvrete_60_74_ans_pourcentage,
        nullif(taux_pauvrete_75_ans_ou_plus_pourcentage, 's') as taux_pauvrete_75_ans_ou_plus_pourcentage,
        nullif(taux_pauvrete_proprietaires_pourcentage, 's') as taux_pauvrete_proprietaires_pourcentage,
        nullif(taux_pauvrete_locataires_pourcentage, 's') as taux_pauvrete_locataires_pourcentage,
        nullif(part_revenus_activite_pourcentage, 's') as part_revenus_activite_pourcentage,
        nullif(part_salaires_traitements_pourcentage, 's') as part_salaires_traitements_pourcentage,
        nullif(part_indemnites_chomage_pourcentage, 's') as part_indemnites_chomage_pourcentage,
        nullif(part_revenus_activites_non_salariees_pourcentage, 's') as part_revenus_activites_non_salariees_pourcentage,
        nullif(part_pensions, 's') as part_pensions,
        nullif(part_revenus_patrimoine_autres_revenus_pourcentage, 's') as part_revenus_patrimoine_autres_revenus_pourcentage,
        nullif(part_ensemble_prestations_sociales_pourcentage, 's') as part_ensemble_prestations_sociales_pourcentage,
        nullif(part_prestations_familiales_pourcentage, 's') as part_prestations_familiales_pourcentage,
        nullif(part_minima_sociaux_pourcentage, 's') as part_minima_sociaux_pourcentage,
        nullif(part_prestations_logement_pourcentage, 's') as part_prestations_logement_pourcentage,
        nullif(part_des_impots_pourcentage, 's') as part_des_impots_pourcentage,
        nullif(decile_1_niveau_vie_euro, 's') as decile_1_niveau_vie_euro,
        nullif(decile_9_niveau_vie_euro, 's') as decile_9_niveau_vie_euro,
        nullif(rapport_interdecile_9_1, 's') as rapport_interdecile_9_1
    from renamed_columns
)

select * from fix_null_text_data