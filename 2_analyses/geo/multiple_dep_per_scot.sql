--- Montre les scots ayant pluseieurs départments

SELECT scot_code, scot_name, multi_dpt
FROM {{ ref('infos_scot') }}
GROUP BY scot_code, scot_name, multi_dpt
HAVING multi_dpt = true