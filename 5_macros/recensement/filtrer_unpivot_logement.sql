{% macro filtrer_unpivot_logement(unpivoted, champs_valeurs_liste, champs_geo, champs_geo_arrivee) %}    

    SELECT
        "{{ champs_geo }}" as  {{ champs_geo_arrivee  }}, 
        CAST("IPONDL" as NUMERIC) as poids_du_logement,
        champs || '_' || valeur AS champs_valeur
    FROM
        unpivoted
    WHERE
        champs || '_' || valeur in (
        {% for champs_valeur_possible in  champs_valeurs_liste %}
            '{{ champs_valeur_possible }}' {% if not loop.last %} , {% endif %}
        {% endfor %})

{% endmacro %}