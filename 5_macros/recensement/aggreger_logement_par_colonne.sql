{% macro aggreger_logement_par_colonne(toutes_colonnes_liste, colonnes_cles_liste, colonne_a_aggreger, champs_geo, champs_geo_arrivee) %}

{% set champs_valeurs_libelle_liste = lister_champs_valeurs_libelle(colonne_a_aggreger) %}

{% set champs_valeurs_liste = champs_valeurs_libelle_liste[0] %}
{% set libelle_liste = champs_valeurs_libelle_liste[1] %}


with unpivoted as (
    {{ unpivot_logement(toutes_colonnes_liste, colonnes_cles_liste, colonne_a_aggreger) }}
), 
unpivot_filtree as (
    {{ filtrer_unpivot_logement(unpivoted, champs_valeurs_liste, champs_geo, champs_geo_arrivee) }}
),
renommee as (
    {{ renommer_logement(unpivot_filtree, champs_valeurs_liste, libelle_liste, champs_geo_arrivee) }}
),
pivoted as (
    {{ pivoter_logement(renommee, libelle_liste, champs_geo_arrivee) }}
)

select * from pivoted
{% endmacro %}