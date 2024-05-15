-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des arrondissements

WITH counts as (
    select 
        sources.cog_arrondissements.code,
        count(*) as num_arr
    from sources.cog_arrondissements 
    group by sources.cog_arrondissements.code
)

select *
from counts
where num_arr > 1 