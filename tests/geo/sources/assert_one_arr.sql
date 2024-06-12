-- Test qu'il n'ya pas de doublons dans la table des codes géographiques des arrondissements

WITH counts as (
    select 
        cog_arrondissements.code,
        count(*) as num_arr
    from {{ source('sources', 'cog_arrondissements')}}  as cog_arrondissements 
    group by cog_arrondissements.code
)

select *
from counts
where num_arr > 1 