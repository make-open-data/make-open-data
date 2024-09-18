{% macro aggreger_logement_par_colonne(colonnes_a_aggreger_liste, colonnes_cles_liste, colonne_a_aggreger, champs_geo, champs_geo_arrivee) %}
 
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
    {{ pivoter_logement(deduplicated, colonne_a_aggreger, champs_geo_arrivee) }}
)

select * from pivoted
{% endmacro %}