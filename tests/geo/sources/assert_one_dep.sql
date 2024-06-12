-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des departements

WITH counts as (
    select 
        cog_departements.code,
        count(*) as num_dep
    from {{ source('sources', 'cog_departements')}} as cog_departements
    group by cog_departements.code
)

select *
from counts
where num_dep > 1 