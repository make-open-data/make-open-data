{% macro pivoter_logement(unpivot_filtree, libelle_liste, champs_geo_arrivee) %}    

    {% set libelle_uniques_liste = [] %}
    {% for libelle in libelle_liste %}
        {% if libelle not in  libelle_uniques_liste %}
            {% do libelle_uniques_liste.append(libelle) %}
        {% endif %}
      {% endfor %}

    select 

    {{ champs_geo_arrivee }},
    {{ dbt_utils.pivot(
        'valeur',
        libelle_uniques_liste,
        agg='sum',
        then_value='poids_du_logement',
    ) }}
    from 
        unpivot_filtree
    group by
        {{ champs_geo_arrivee }}

{% endmacro %}
