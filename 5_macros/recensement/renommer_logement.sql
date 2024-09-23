{% macro renommer_logement(unpivot_filtree, champs_valeurs_liste, libelle_liste, champs_geo_arrivee) %}    
    SELECT
        {{ champs_geo_arrivee }},
        CASE champs_valeur
            {% for valeur, libelle in zip(champs_valeurs_liste, libelle_liste) %}
                when '{{ valeur }}' then '{{ libelle }}'
            {% endfor %}
        END AS champs_valeur_renomme,
        CAST(SUM(CAST(poids_du_logement as NUMERIC)) AS INT) as population_par_champs_valeur
    FROM
        unpivot_filtree
    GROUP BY
        {{ champs_geo_arrivee }},
        champs_valeur_renomme
{% endmacro %}