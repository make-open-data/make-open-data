{% macro concatener_logement(unpivoted, champs_geo, champs_geo_arrivee) %}    
    SELECT
        "{{ champs_geo }}" as  {{ champs_geo_arrivee  }},
        CAST("IPONDL" as NUMERIC) as poids_du_logement,
        champs,
        valeur,
        champs || '__' || valeur AS champs__valeur
    FROM
        unpivoted
{% endmacro %}