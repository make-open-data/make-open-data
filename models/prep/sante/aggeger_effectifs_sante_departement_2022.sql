{{ config(materialized='table') }}

with aggreger_effectif_sante_unpivot as (
	select 
		region,
		libelle_region,
		departement,
		libelle_departement,
		profession_sante,
		sum(cast(effectif as numeric)) as effectif
	FROM {{ source('sources', 'professionels_sante') }}
	where (annee = '2022') and (libelle_departement != 'Tout département')
	group by region, departement, libelle_region, libelle_departement, profession_sante
),
aggreger_effectif_sante_departements as (
	select 
		region,
		libelle_region,
		departement,
		libelle_departement,
		{{ dbt_utils.pivot(
			'profession_sante',
			dbt_utils.get_column_values(source('sources', 'professionels_sante') , 'profession_sante'),
			agg='sum',
			then_value='effectif'
		) }}
  	FROM aggreger_effectif_sante_unpivot
	group by region, libelle_region, departement, libelle_departement
)

select * from aggreger_effectif_sante_departements

