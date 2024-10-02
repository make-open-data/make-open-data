-- L'insee ne fournit que les infos sur les iris des communes irisées
-- Ajouter les autres communes est impossible car la table commune ne reporte pas les mêmes champs
-- Aussi, revenu par isis utilise la géographie 2022 qu'il convient de transposer avec la géographie 2024
-- {{ config(materialized='table') }}

with filosofi_iris as (
    select * 
    from {{ source('sources', 'filosofi_iris_2021')}}

),
renamed_columns as (
    select
        "IRIS" as code_iris_2022_filosofi,
        {{ nettoyer_modalite_revenu("DEC_PIMP21") }} as part_menages_fiscaux_imposes_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_TP6021") }} as taux_bas_revenus_declares_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_INCERT21") }} as incertitude,
        {{ nettoyer_modalite_revenu("DEC_Q121") }} as quartile_1_euro,
        {{ nettoyer_modalite_revenu("DEC_MED21") }} as mediane_euro,
        {{ nettoyer_modalite_revenu("DEC_Q321") }} as quartile_3_euro,
        {{ nettoyer_modalite_revenu("DEC_EQ21") }} as ecart_interquartile_rapporte_mediane,
        {{ nettoyer_modalite_revenu("DEC_D121") }} as decile_1_euro,
        {{ nettoyer_modalite_revenu("DEC_D221") }} as decile_2_euro,
        {{ nettoyer_modalite_revenu("DEC_D321") }} as decile_3_euro,
        {{ nettoyer_modalite_revenu("DEC_D421") }} as decile_4_euro,
        {{ nettoyer_modalite_revenu("DEC_D621") }} as decile_6_euro,
        {{ nettoyer_modalite_revenu("DEC_D721") }} as decile_7_euro,
        {{ nettoyer_modalite_revenu("DEC_D821") }} as decile_8_euro,
        {{ nettoyer_modalite_revenu("DEC_D921") }} as decile_9_euro,
        {{ nettoyer_modalite_revenu("DEC_RD21") }} as rapport_interdecile_d9_d1,
        {{ nettoyer_modalite_revenu("DEC_S80S2021") }} as s80_s20,
        {{ nettoyer_modalite_revenu("DEC_GI21") }} as indice_gini,
        {{ nettoyer_modalite_revenu("DEC_PACT21") }} as part_revenus_activite_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_PTSA21") }} as part_salaires_traitements_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_PCHO21") }} as part_indemnites_chomage_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_PBEN21") }} as part_revenus_activites_non_salariees_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_PPEN21") }} as part_pensions_retraites_rentes_pourcentage,
        {{ nettoyer_modalite_revenu("DEC_PAUT21") }} as part_autres_revenus_pourcentage
    from filosofi_iris
), 
aggregated_with_infos_iris as (
    SELECT
      *
    FROM
      renamed_columns
    JOIN
	    {{ ref('infos_iris') }} as infos_iris
    ON
      renamed_columns.code_iris_2024_filosofi = infos_iris.code_iris_2024
  )

select * from aggregated_with_infos_iris
