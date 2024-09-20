{% macro aggreger_logement_par_colonne(colonnes_a_aggreger_liste, colonnes_cles_liste, colonne_a_aggreger, champs_geo, champs_geo_arrivee) %}

{% set champs_valeurs_libelle_liste = lister_champs_valeurs_libelle(colonne_a_aggreger) %}

{% set champs_valeurs_liste = champs_valeurs_libelle_liste[0] %}
{% set libelle_liste = champs_valeurs_libelle_liste[1] %}


with unpivoted as (
    {{ unpivot_logement(colonnes_a_aggreger_liste, colonnes_cles_liste, colonne_a_aggreger) }}
), 
concatenated as (
    {{ concatener_logement(unpivoted, champs_geo, champs_geo_arrivee) }}
),
deduplicated as (
    {{ dedupliquer_logement(concatenated, champs_geo_arrivee) }}
),
pivoted as (
    {{ pivoter_logement(deduplicated, colonne_a_aggreger, champs_valeurs_liste, champs_geo_arrivee) }}
),
renamed as (
    {{ renommer_colonnes(pivoted, colonne_a_aggreger, champs_valeurs_liste, libelle_liste, champs_geo_arrivee) }}
)

select * from renamed
{% endmacro %}