{% macro aggreger_par_scot(theme) %}

{% set libelle_logement_query %}
  SELECT DISTINCT 
  libelle_a_afficher_apres_aggregation
  FROM {{ ref('logement_2020_valeurs') }}
  WHERE theme = '{{ theme }}'
{% endset %}

{% set libelle_logement_resultats = run_query(libelle_logement_query) %}
{% set libelle_logement_liste = ['nombre_de_menage_base_ou_logements_occupee', 'nombre_de_logements_occasionnels',
                                 'nombre_de_logements_residences_secondaires', 'nombre_de_logements_vacants',
                                 'nombre_de_logements_total_tous_status_occupation'] %}
{% for row in libelle_logement_resultats %}
    {% do libelle_logement_liste.append(row[0]) %}
{% endfor %}

select scot."Id SCoT" as scot_code,
{% for libelle in libelle_logement_liste %}
    SUM(comm."{{ libelle }}") as "{{ libelle }}"
    {% if not loop.last %}, {% endif %}
{% endfor %}
from {{ ref(theme ~ '_communes') }} comm
join {{ source('sources', 'communes_to_scot') }} scot
    on comm.code_commune = scot."INSEE commune"
where scot."Id SCoT" is not null
group by scot."Id SCoT"

{% endmacro %}
