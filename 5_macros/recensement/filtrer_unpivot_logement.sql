{% macro filtrer_unpivot_logement(unpivoted, libelle_liste, champs_geo, champs_geo_arrivee) %}    

    SELECT
        {{ champs_geo_arrivee  }}, 
        poids_du_logement,
        valeur
    FROM
        unpivoted
    WHERE
        valeur in (
        {% for valeur_libelle in libelle_liste %}
            '{{ valeur_libelle }}' {% if not loop.last %} , {% endif %}
        {% endfor %})

{% endmacro %}