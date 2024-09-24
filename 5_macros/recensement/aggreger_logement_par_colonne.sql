{% macro aggreger_logement_par_colonne(table_renomee, colonnes_a_aggreger_liste, colonne_a_aggreger, colonnes_cles_liste, champs_geo_arrivee) %}

{% set champs_valeurs_libelle_liste = lister_champs_valeurs_libelle(colonne_a_aggreger) %}

{% set libelle_liste = champs_valeurs_libelle_liste[1] %}


with unpivoted as (
    {{ unpivot_logement(table_renomee, colonnes_a_aggreger_liste, colonnes_cles_liste, colonne_a_aggreger) }}
), 
unpivot_filtree as (
    {{ filtrer_unpivot_logement(unpivoted, libelle_liste, champs_geo, champs_geo_arrivee) }}
),
pivoted as (
    {{ pivoter_logement(unpivot_filtree, libelle_liste, champs_geo_arrivee) }}
)

select * from pivoted
{% endmacro %}