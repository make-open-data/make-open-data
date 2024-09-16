{% macro aggreger_logement_par_colonne(variante_logement, colonnes_a_aggreger_list, colonne_a_aggreger, champs_geo) %}    


with unpivoted as (
    {{ unpivot_logement(variante_logement, colonnes_a_aggreger_list, colonne_a_aggreger) }}
), 
concatenated as (
    {{ concatener_logement(unpivoted, champs_geo) }}
),
deduplicated as (
    {{ dedupliquer_logement(concatenated, champs_geo) }}
),
pivoted as (
    {{ pivoter_logement(variante_logement, deduplicated, colonne_a_aggreger, champs_geo) }}
)

select * from pivoted
{% endmacro %}