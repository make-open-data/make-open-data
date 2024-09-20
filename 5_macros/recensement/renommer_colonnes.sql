{% macro renommer_colonnes(pivoted, colonne_a_aggreger, champs_valeurs_liste, libelle_liste, champs_geo_arrivee) %}    

select 
    {{ champs_geo_arrivee }},

    {% for champs_valeur, libelle in zip(champs_valeurs_liste, libelle_liste) %}
        "{{ champs_valeur }}" as {{ libelle }}
        {% if not loop.last %} , {% endif %}
    {% endfor %}
    
from 
    pivoted 

{% endmacro %}