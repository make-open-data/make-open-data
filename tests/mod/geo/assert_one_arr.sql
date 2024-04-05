-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des arrondissements

WITH counts as (
    select 
        cga."ARR",
        count(*) as num_arr
    from codes_geographiques_arrondissements as cga
    group by cga."ARR"
)

select *
from counts
where num_arr > 1 