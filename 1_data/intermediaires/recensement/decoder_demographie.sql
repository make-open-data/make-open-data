{{ 
    config(
        materialized='view',
        schema='intermediaires'
    ) 
}}

WITH logement AS (
    select * from {{ source('sources', 'logement_2020')}}
),
decode_logement AS (
    {{ renommer_colonnes_valeurs_logement(logement, 'logement_2020_demographie_codes') }}
),
decode_logement_iris AS(
    select 
        *,
        CASE 
		    WHEN code_iris_incomplet = 'ZZZZZZZZZ' THEN CONCAT(code_commune_insee, '0000')
		    ELSE code_iris_incomplet
	    END as code_iris 
    from decode_logement
)

SELECT 
    *
FROM 
    decode_logement_iris