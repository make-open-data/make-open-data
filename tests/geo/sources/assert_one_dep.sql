-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des departements

WITH counts as (
    select 
        sources.cog_departements.code,
        count(*) as num_dep
    from sources.cog_departements
    group by sources.cog_departements.code
)

select *
from counts
where num_dep > 1 