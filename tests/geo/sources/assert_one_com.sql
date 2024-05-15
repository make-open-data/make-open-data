-- Une commune peut avoir plusieurs types
-- COM	Commune / COMA	Commune associée / COMD	Commune déléguée / ARM	Arrondissement municipal
-- Les COM sont celles existantes, les autres types sont des legacy de fusions ou disparitions de communes

WITH counts as (
    select 
        sources.cog_communes.code,
        count(*) as num_com
    from sources.cog_communes
    where sources.cog_communes.type = 'commune-actuelle'
    group by sources.cog_communes.code
)

select *
from counts
where num_com > 1 