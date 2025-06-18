{{ config(materialized='table') }}

select recensement_theme_scot.*,
       infos.scot_name,
       infos.population,
       infos.contour
from ({{ aggreger_par_scot('activite') }}) recensement_theme_scot
left join {{ ref('infos_scot') }} infos
on recensement_theme_scot.scot_code = infos.scot_code
