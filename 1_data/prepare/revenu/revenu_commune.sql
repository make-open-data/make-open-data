{{ config(materialized='table') }}

with filosofi_commune as (
    select * 
    from {{ source('sources', 'filosofi_commune_2021')}}

),
renamed_columns as (
    select
        "CODGEO" as code_commune_2024,
        {{ nettoyer_modalite_revenu("NBMENFISC21") }} as nombre_menages_fiscaux,
        {{ nettoyer_modalite_revenu("NBPERSMENFISC21") }} as nombre_personnes,
        {{ nettoyer_modalite_revenu("MED21") }} as mediane_niveau_vie_euro,
        {{ nettoyer_modalite_revenu("PIMP21") }} as part_menages_fiscaux_imposes_pourcentage,
        {{ nettoyer_modalite_revenu("TP6021") }} as taux_pauvrete_ensemble_pourcentage,
        {{ nettoyer_modalite_revenu("TP60AGE121") }} as taux_pauvrete_moins_30_ans_pourcentage,
        {{ nettoyer_modalite_revenu("TP60AGE221") }} as taux_pauvrete_30_39_ans_pourcentage,
        {{ nettoyer_modalite_revenu("TP60AGE321") }} as taux_pauvrete_40_49_ans_pourcentage,
        {{ nettoyer_modalite_revenu("TP60AGE421") }} as taux_pauvrete_50_59_ans_pourcentage,
        {{ nettoyer_modalite_revenu("TP60AGE521") }} as taux_pauvrete_60_74_ans_pourcentage,
        {{ nettoyer_modalite_revenu("TP60AGE621") }} as taux_pauvrete_75_ans_ou_plus_pourcentage,
        {{ nettoyer_modalite_revenu("TP60TOL121") }} as taux_pauvrete_proprietaires_pourcentage,
        {{ nettoyer_modalite_revenu("TP60TOL221") }} as taux_pauvrete_locataires_pourcentage,
        {{ nettoyer_modalite_revenu("PACT21") }} as part_revenus_activite_pourcentage,
        {{ nettoyer_modalite_revenu("PTSA21") }} as part_salaires_traitements_pourcentage,
        {{ nettoyer_modalite_revenu("PCHO21") }} as part_indemnites_chomage_pourcentage,
        {{ nettoyer_modalite_revenu("PBEN21") }} as part_revenus_activites_non_salariees_pourcentage,
        {{ nettoyer_modalite_revenu("PPEN21") }} as part_pensions,
        {{ nettoyer_modalite_revenu("PPAT21") }} as part_revenus_patrimoine_autres_revenus_pourcentage,
        {{ nettoyer_modalite_revenu("PPSOC21") }} as part_ensemble_prestations_sociales_pourcentage,
        {{ nettoyer_modalite_revenu("PPFAM21") }} as part_prestations_familiales_pourcentage,
        {{ nettoyer_modalite_revenu("PPMINI21") }} as part_minima_sociaux_pourcentage,
        {{ nettoyer_modalite_revenu("PPLOGT21") }} as part_prestations_logement_pourcentage,
        {{ nettoyer_modalite_revenu("PIMPOT21") }} as part_des_impots_pourcentage,
        {{ nettoyer_modalite_revenu("D121") }} as decile_1_niveau_vie_euro,
        {{ nettoyer_modalite_revenu("D921") }} as decile_9_niveau_vie_euro,
        {{ nettoyer_modalite_revenu("RD21") }} as rapport_interdecile_9_1
    from filosofi_commune
),
aggregated_with_infos_communes as (
    SELECT
      *
    FROM
      renamed_columns
    JOIN
	    {{ ref('infos_communes') }} as infos_communes
    ON
      renamed_columns.code_commune_2024 = infos_communes.code_commune
  )

select * from aggregated_with_infos_communes