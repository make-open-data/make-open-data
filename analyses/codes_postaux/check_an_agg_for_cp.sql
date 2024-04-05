-- Visualiser les dept et région pour un CP multi départements
select
    LPAD(CAST(cp.code_postal AS TEXT), 5, '0') as code_postal,
    cc."COM" as code_commune_insee,
    cc."ARR" as code_arrondissement,
    cc."DEP" as code_departement,
    cc."REG" as code_region
from codes_postaux cp
left join codes_geographiques_communes cc on cp.code_commune_insee = cc."COM" and cc."TYPECOM" = 'COM'
where code_postal = '01410'