-- Les departements et les régions sont données par commune
-- Il existe plusieurs codes postaux pour une commune et plusieurs communes pour un code postal
-- Il convient de vérifier que pour un code postal donné, après fusion avec la table communes,
-- Il n'y a pas qu'un seul arrondissement, un seul département et une seule région
with merged_data as (
    select
        LPAD(CAST(cp.code_postal AS TEXT), 5, '0') as code_postal,
        -- cc."ARR" as code_arrondissement,
        cc."DEP" as code_departement,
        cc."REG" as code_region
    from codes_postaux cp
    inner join codes_geographiques_communes cc on cp.code_commune_insee = cc."COM" and cc."TYPECOM" = 'COM'
    -- Remplacer par left join à l'inclusions des territoire d'outre mer TOM 
    -- Puisque les codes communes ne sont pas renseignés pour ces territoires dans codes_geographiques_communes
    -- La Réunion est une region d'outre, mais pas un territoire d'outre mer, dès lors elle est incluse dans les codes_geographiques_communes
),

counts as (
    select 
        code_postal,
        --count(distinct code_arrondissement) as num_arr,
        count(distinct code_departement) as num_dep,
        count(distinct code_region) as num_reg
    from merged_data
    group by code_postal
)

select *
from counts
where num_dep > 1 or num_reg > 1