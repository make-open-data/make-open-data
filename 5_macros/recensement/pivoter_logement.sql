{% macro pivoter_logement(renommee, libelle_liste, champs_geo_arrivee) %}    

    {% set libelle_uniques_liste = [] %}
    {% for libelle in libelle_liste %}
        {% if libelle not in  libelle_uniques_liste %}
            {% do libelle_uniques_liste.append(libelle) %}
        {% endif %}
      {% endfor %}

    select 

    {{ champs_geo_arrivee }},
    {{ dbt_utils.pivot(
        'champs_valeur_renomme',
        libelle_uniques_liste,
        agg='sum',
        then_value='population_par_champs_valeur',
    ) }}
    from 
        renommee
    group by
        {{ champs_geo_arrivee }}

{% endmacro %}
