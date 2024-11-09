{{ config(materialized='table') }}

with aggreger_effectif_sante_unpivot as (
    SELECT departement, profession_sante,annee, sum(cast(effectif as numeric)) as effectif FROM sources.professionels_sante
    GROUP BY departement, profession_sante, annee
),
     aggreger_effectif_sante_departements as (
         select
             departement,
             annee,
             {{ dbt_utils.pivot(
                 'profession_sante',
                 dbt_utils.get_column_values(source('sources', 'professionels_sante') , 'profession_sante'),
                 agg='sum',
                 then_value='effectif'
             ) }}
         FROM aggreger_effectif_sante_unpivot
         group by departement, annee
     )


select 
	aggreger_effectif_sante_departements.*,
	infos_par_departement.*
from aggreger_effectif_sante_departements
left join {{ ref('infos_departements') }} infos_par_departement 
on aggreger_effectif_sante_departements.departement = infos_par_departement.code_departement

