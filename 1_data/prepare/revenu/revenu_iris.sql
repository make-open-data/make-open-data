{{ config(materialized='table') }}

with filosofi_iris as (
    select * 
    from {{ source('sources', 'filosofi_iris_2021')}}

),
remaned_columns as (
    select
        "IRIS" as iris,
        "DEC_PIMP21" as part_menages_fiscaux_imposes_pourcentage,
        "DEC_TP6021" as taux_bas_revenus_declarés_60_pourcentage,
        "DEC_INCERT21" as incertitude_pimp_tp60,
        "DEC_Q121" as quartile_1_euro,
        "DEC_MED21" as mediane_euro,
        "DEC_Q321" as quartile_3_euro,
        "DEC_EQ21" as ecart_interquartile_rapporte_mediane,
        "DEC_D121" as decile_1_euro,
        "DEC_D221" as decile_2_euro,
        "DEC_D321" as decile_3_euro,
        "DEC_D421" as decile_4_euro,
        "DEC_D621" as decile_6_euro,
        "DEC_D721" as decile_7_euro,
        "DEC_D821" as decile_8_euro,
        "DEC_D921" as decile_9_euro,
        "DEC_RD21" as rapport_interdecile_d9_d1,
        "DEC_S80S2021" as s80_s20,
        "DEC_GI21" as indice_gini,
        "DEC_PACT21" as part_revenus_activite_pourcentage,
        "DEC_PTSA21" as dont_part_salaires_traitements_pourcentage,
        "DEC_PCHO21" as dont_part_indemnites_chômage_pourcentage,
        "DEC_PBEN21" as dont_part_revenus_activites_non_salariees_pourcentage,
        "DEC_PPEN21" as part_pensions_retraites_rentes_pourcentage,
        "DEC_PAUT21" as part_autres_revenus_pourcentage,
        "DEC_NOTE21" as note_precaution
    from filosofi_iris
)

select * from remaned_columns
