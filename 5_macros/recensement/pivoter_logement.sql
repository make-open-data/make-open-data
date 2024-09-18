{% macro pivoter_logement(deduplicated, colonne_a_aggreger, champs_geo_arrivee) %}    



{% set colonne_a_aggreger_values_list = lister_colonne_a_aggrger_valeurs(colonne_a_aggreger) %}

    select 

    {{ champs_geo_arrivee }},
    {{ dbt_utils.pivot(
        'champs__valeur',
        colonne_a_aggreger_values_list,
        agg='sum',
        then_value='population_par_champs_valeur',
    ) }}
    from 
        deduplicated
    group by
        {{ champs_geo_arrivee }}

{% endmacro %}
