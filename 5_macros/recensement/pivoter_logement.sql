{% macro pivoter_logement(deduplicated, colonne_a_aggreger, colonne_a_aggreger_values_list, champs_geo_arrivee) %}    

    select 

    {{ champs_geo_arrivee }},
    {{ dbt_utils.pivot(
        'champs_valeur',
        colonne_a_aggreger_values_list,
        agg='sum',
        then_value='population_par_champs_valeur',
    ) }}
    from 
        deduplicated
    group by
        {{ champs_geo_arrivee }}

{% endmacro %}
