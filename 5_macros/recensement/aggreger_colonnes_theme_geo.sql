{% macro aggreger_colonnes_theme_geo(theme, table_renomee, champs_geo_arrivee) %}

{% set colonnes_a_aggreger_liste = lister_colonnes_par_theme(theme) %}

{% set colonnes_cles_liste = ['poids_du_logement', 'code_commune_insee', 'code_iris'] %}

with poids_par_geo as (
    SELECT 
      {{ champs_geo_arrivee }},
      CAST( SUM(CAST(poids_du_logement AS numeric)) AS INT) AS nombre_de_logements
    FROM
      {{ ref(table_renomee) }}
    GROUP BY
      {{ champs_geo_arrivee }}
  ),
  aggregated as (

    SELECT * 

    FROM poids_par_geo

    {% for colonne_a_aggreger in colonnes_a_aggreger_liste %}

      LEFT JOIN ( {{ aggreger_logement_par_colonne(table_renomee, colonnes_a_aggreger_liste, colonne_a_aggreger, colonnes_cles_liste, champs_geo_arrivee) }}  ) as alias_{{ colonne_a_aggreger }}_par_geo
      USING ({{ champs_geo_arrivee }})

    {% endfor %}

  )

select * from aggregated
{% endmacro %}
