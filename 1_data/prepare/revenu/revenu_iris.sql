{{ config(materialized='table') }}

with filosofi_iris as (
    select * 
    from {{ source('sources', 'filosofi_iris_2021')}}

),
remaned_columns as (
    select
        "IRIS" as code_iris_2024,
        nullif("DEC_PIMP21", 's') as part_menages_fiscaux_imposes_pourcentage,
        nullif("DEC_TP6021", 's') as taux_bas_revenus_declares_pourcentage,
        nullif("DEC_INCERT21", 's') as incertitude,
        nullif("DEC_Q121", 's') as quartile_1_euro,
        nullif("DEC_MED21", 's') as mediane_euro,
        nullif("DEC_Q321", 's') as quartile_3_euro,
        nullif("DEC_EQ21", 's') as ecart_interquartile_rapporte_mediane,
        nullif("DEC_D121", 's') as decile_1_euro,
        nullif("DEC_D221", 's') as decile_2_euro,
        nullif("DEC_D321", 's') as decile_3_euro,
        nullif("DEC_D421", 's') as decile_4_euro,
        nullif("DEC_D621", 's') as decile_6_euro,
        nullif("DEC_D721", 's') as decile_7_euro,
        nullif("DEC_D821", 's') as decile_8_euro,
        nullif("DEC_D921", 's') as decile_9_euro,
        nullif("DEC_RD21", 's') as rapport_interdecile_d9_d1,
        nullif("DEC_S80S2021", 's') as s80_s20,
        nullif("DEC_GI21", 's') as indice_gini,
        nullif("DEC_PACT21", 's') as part_revenus_activite_pourcentage,
        nullif("DEC_PTSA21", 's') as part_salaires_traitements_pourcentage,
        nullif("DEC_PCHO21", 's') as part_indemnites_chomage_pourcentage,
        nullif("DEC_PBEN21", 's') as part_revenus_activites_non_salariees_pourcentage,
        nullif("DEC_PPEN21", 's') as part_pensions_retraites_rentes_pourcentage,
        nullif("DEC_PAUT21", 's') as part_autres_revenus_pourcentage
    from filosofi_iris
)

select * from remaned_columns
