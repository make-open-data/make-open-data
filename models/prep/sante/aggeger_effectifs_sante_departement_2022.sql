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
	where (annee = '2022') and (libelle_departement != 'Tout département')  and (libelle_departement != 'FRANCE')
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
),
infos_par_departement as (
	select 
		code_departement,
		sum(cast(population as numeric)) as population_departement,
		avg(commune_latitude) as latitude_centre_departement,
		avg(commune_longitude) as longitude_centre_departement
	from {{ ref('geo_communes') }}
	group by code_departement
)

select 
	aggreger_effectif_sante_departements.*,
	infos_par_departement.population_departement,
	infos_par_departement.latitude_centre_departement,
	infos_par_departement.longitude_centre_departement
from aggreger_effectif_sante_departements
left join infos_par_departement 
on aggreger_effectif_sante_departements.departement = infos_par_departement.code_departement

