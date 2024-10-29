{% macro aggreger_supra_commune(theme, nouveau_niveau_geo) %}

{% set libelle_logement_query %}

  SELECT DISTINCT 
  libelle_a_afficher_apres_aggregation
  FROM {{ ref('logement_2020_valeurs') }}
  WHERE theme = '{{ theme }}'
{% endset %}

{% set libelle_logement_resultats = run_query(libelle_logement_query) %}


{% set libelle_logement_liste = [] %}
{% for row in libelle_logement_resultats %}
    {% do libelle_logement_liste.append(row[0]) %}
{% endfor %}


select {{ nouveau_niveau_geo }},
{% for libelle in  libelle_logement_liste%}
    SUM("{{ libelle }}") as "{{ libelle }}"
    {% if not loop.last %} , {% endif %}
{% endfor %}
from {{ ref(theme+'_communes')}}
group by {{ nouveau_niveau_geo }}

{% endmacro %}