{% macro preparer_dvf_biens_immobilier(millesime) %}

WITH source_dvf AS (
    {% if target.name == 'production' %}
        select * from {{ source('sources', 'dvf_' + millesime) }}
    {% else %}
        select * from {{ source('sources', 'dvf_' + millesime + '_dev') }}
    {% endif %}
),
ventes_immobiliers_filtrees AS (
    {{ filtrer_ventes_immobilieres(source_dvf) }}
),
ventes_immobiliers_aggregees_au_bien AS (
    {{ aggreger_ventes_immobiliers(ventes_immobiliers_filtrees) }}
),
bien_principal_de_la_vente AS (
    {{ selectionner_bien_principal(ventes_immobiliers_filtrees) }}
) 
SELECT 
    bien_principal_de_la_vente.id_mutation,
    bien_principal_de_la_vente.valeur_fonciere,
    bien_principal_de_la_vente.longitude,
    bien_principal_de_la_vente.latitude,
    ventes_immobiliers_aggregees_au_bien.total_pieces,
    ventes_immobiliers_aggregees_au_bien.total_surface,
    bien_principal_de_la_vente.type_local,
    bien_principal_de_la_vente.code_postal,
    bien_principal_de_la_vente.code_commune,
    ST_SetSRID(ST_MakePoint(bien_principal_de_la_vente.longitude, bien_principal_de_la_vente.latitude), 4326) as geopoint,
    bien_principal_de_la_vente.valeur_fonciere / ventes_immobiliers_aggregees_au_bien.total_surface as prix_m2,
    infos_communes.nom_commune,
    infos_communes.code_arrondissement,
    infos_communes.code_departement,
    infos_communes.code_region,
    infos_communes.nom_arrondissement,
    infos_communes.nom_departement,
    infos_communes.nom_region,
    {{ millesime }} as millesime
FROM 
    bien_principal_de_la_vente
JOIN 
    ventes_immobiliers_aggregees_au_bien ON ventes_immobiliers_aggregees_au_bien.id_mutation = bien_principal_de_la_vente.id_mutation
LEFT JOIN
    {{ ref('infos_communes') }} as infos_communes on infos_communes.code_commune = bien_principal_de_la_vente.code_commune

{% endmacro %}