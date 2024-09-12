-- Une commune peut avoir plusieurs types
-- COM	Commune / COMA	Commune associée / COMD	Commune déléguée / ARM	Arrondissement municipal
-- Les COM sont celles existantes, les autres types sont des legacy de fusions ou disparitions de communes

WITH counts as (
    select 
        cog_communes.code,
        count(*) as num_com
    from {{ source('sources', 'cog_communes')}}  as cog_communes
    where cog_communes.type = 'commune-actuelle'
    group by cog_communes.code
)

select *
from counts
where num_com > 1 