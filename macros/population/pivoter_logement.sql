{% macro pivoter_logement(deduplicated, colonne_a_aggreger_values_list, colonne_index) %}    

    select 

    code_commune_insee as code_commune_insee_{{ colonne_index }},
    {{ dbt_utils.pivot(
        'champs__valeur',
        colonne_a_aggreger_values_list,
        agg='sum',
        then_value='population_par_commune_champs_valeur',
    ) }}
    from 
        deduplicated
    group by
        code_commune_insee

{% endmacro %}
