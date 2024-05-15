-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des régions

WITH counts as (
    select 
        sources.cog_regions.code,
        count(*) as num_reg
    from sources.cog_regions
    group by sources.cog_regions.code
)

select *
from counts
where num_reg > 1 