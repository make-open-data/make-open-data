{{ config(materialized='table') }}

with aggreger_effectif_sante_unpivot as (
	select 
		departement,
		libelle_departement,
		profession_sante,
		sum(cast(effectif as numeric)) as effectif
	FROM {{ source('sources', 'professionels_sante') }}
	where (annee = '2022') and (libelle_departement != 'Tout département')  and (libelle_departement != 'FRANCE')
	group by departement, libelle_departement, profession_sante
),
aggreger_effectif_sante_departements as (
	select 
		departement,
		{{ dbt_utils.pivot(
			'profession_sante',
			dbt_utils.get_column_values(source('sources', 'professionels_sante') , 'profession_sante'),
			agg='sum',
			then_value='effectif'
		) }}
  	FROM aggreger_effectif_sante_unpivot
	group by departement
)

select 
	aggreger_effectif_sante_departements.*,
	infos_par_departement.*
from aggreger_effectif_sante_departements
left join {{ ref('infos_departements') }} infos_par_departement 
on aggreger_effectif_sante_departements.departement = infos_par_departement.code_departement

