-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des departements

WITH counts as (
    select 
        cgd."DEP",
        count(*) as num_dep
    from codes_geographiques_departements as cgd
    group by cgd."DEP"
)

select *
from counts
where num_dep > 1 