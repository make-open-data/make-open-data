{% macro aggreger_logement_par_colonne(variante_logement, colonnes_a_aggreger_list, colonne_a_aggreger) %}    


with unpivoted as (
    {{ unpivot_logement(variante_logement, colonnes_a_aggreger_list, colonne_a_aggreger) }}
), 
concatenated as (
    {{ concatener_logement(unpivoted) }}
),
deduplicated as (
    {{ dedupliquer_logement(concatenated) }}
),
pivoted as (
    {{ pivoter_logement(variante_logement, deduplicated, colonne_a_aggreger) }}
)

select * from pivoted
{% endmacro %}