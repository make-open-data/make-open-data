-- Une commune peut avoir plusieurs types
-- COM	Commune / COMA	Commune associée / COMD	Commune déléguée / ARM	Arrondissement municipal
-- Les COM sont celles existantes, les autres types sont des legacy de fusions ou disparitions de communes

WITH counts as (
    select 
        cgc."COM",
        count(*) as num_com
    from codes_geographiques_communes as cgc
    where cgc."TYPECOM" = 'COM'
    group by cgc."COM"
)

select *
from counts
where num_com > 1 