{% macro aggreger_logement_par_colonne(colonnes_a_aggreger_list, colonne_index, colonne_a_aggreger) %}    


with unpivoted as (
    {{ unpivot_logement(colonnes_a_aggreger_list, colonne_a_aggreger) }}
), 
concatenated as (
    {{ concatener_logement(unpivoted) }}
),
deduplicated as (
    {{ dedupliquer_logement(concatenated) }}
),
pivoted as (
    {{ pivoter_logement(deduplicated, colonne_a_aggreger, colonne_index) }}
)

select * from pivoted
{% endmacro %}