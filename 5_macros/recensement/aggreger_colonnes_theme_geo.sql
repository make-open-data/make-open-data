{% macro aggreger_colonnes_theme_geo(theme, champs_geo, champs_geo_arrivee) %}

{% set toutes_colonnes_liste = lister_toutes_colonnes() %}

{% set colonnes_a_aggreger_liste = lister_colonnes_par_theme(theme) %}

{% set colonnes_cles_liste = lister_colonnes_par_theme('CLE') %}

with poids_par_geo as (
    SELECT 
      "{{ champs_geo }}" as {{ champs_geo_arrivee }},
      CAST( SUM(CAST("IPONDL" AS numeric)) AS INT) AS nombre_de_logements
        {% if target.name == 'production' %}
            from {{ source('sources', 'logement_2020') }}
        {% else %}
            from {{ source('sources', 'logement_2020_dev') }}
        {% endif %}
    GROUP BY
      {{ champs_geo_arrivee }}
  ),
  aggregated as (

    SELECT * 

    FROM poids_par_geo

    {% for colonne_a_aggreger in colonnes_a_aggreger_liste %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne(toutes_colonnes_liste, colonnes_cles_liste, colonne_a_aggreger, champs_geo, champs_geo_arrivee) }}  )
      USING ({{ champs_geo_arrivee }})

    {% endfor %}

  )

select * from aggregated
{% endmacro %}