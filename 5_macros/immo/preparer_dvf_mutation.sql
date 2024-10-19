{% macro preparer_dvf_mutation(millesime) %}

WITH source_dvf AS (
    {% if target.name == 'production' %}
        select * from {{ source('sources', 'dvf_' + millesime) }}
    {% else %}
        select * from {{ source('sources', 'dvf_' + millesime + '_dev') }}
    {% endif %}
),
filtrer_dvf AS (
    {{ filtrer_dvf(source_dvf) }}
),
aggreger_dvf AS (
    {{ aggreger_dvf(filtrer_dvf) }}
),
bien_principal_dvf AS (
    {{ selectionner_bien_principal_dvf(filtrer_dvf) }}
) 
SELECT 
    bien_principal_dvf.id_mutation,
    bien_principal_dvf.valeur_fonciere,
    bien_principal_dvf.longitude,
    bien_principal_dvf.latitude,
    aggreger_dvf.total_pieces,
    aggreger_dvf.total_surface,
    bien_principal_dvf.type_local,
    bien_principal_dvf.code_postal,
    bien_principal_dvf.code_commune,
    ST_SetSRID(ST_MakePoint(bien_principal_dvf.latitude, bien_principal_dvf.longitude), 4326) as geopoint,
    bien_principal_dvf.valeur_fonciere / aggreger_dvf.total_surface as prix_m2,
    infos_communes.nom_commune,
    infos_communes.code_arrondissement,
    infos_communes.code_departement,
    infos_communes.code_region,
    infos_communes.nom_arrondissement,
    infos_communes.nom_departement,
    infos_communes.nom_region,
    {{ millesime }} as millesime
FROM 
    bien_principal_dvf
JOIN 
    aggreger_dvf ON aggreger_dvf.id_mutation = bien_principal_dvf.id_mutation
LEFT JOIN
    {{ ref('infos_communes') }} as infos_communes on infos_communes.code_commune = bien_principal_dvf.code_commune

{% endmacro %}