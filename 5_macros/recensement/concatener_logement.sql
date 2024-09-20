{% macro concatener_logement(unpivoted, champs_geo, champs_geo_arrivee) %}    
    SELECT
        "{{ champs_geo }}" as  {{ champs_geo_arrivee  }},
        CAST("IPONDL" as NUMERIC) as poids_du_logement,
        champs,
        valeur,
        champs || '_' || valeur AS champs_valeur
    FROM
        unpivoted
{% endmacro %}