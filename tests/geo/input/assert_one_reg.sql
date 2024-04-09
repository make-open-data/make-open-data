-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des régions

WITH counts as (
    select 
        cgr."REG",
        count(*) as num_reg
    from codes_geographiques_regions as cgr
    group by cgr."REG"
)

select *
from counts
where num_reg > 1 