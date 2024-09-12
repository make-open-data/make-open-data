{% macro renommer_colonnes_valeurs_logement(logement, codes_variante_logement) %}
  
  {% set seed_query %}
    SELECT DISTINCT 
      code_col, 
      lib_col, 
      code_ou_libelle_valeurs
    FROM {{ ref(codes_variante_logement) }} as logement_2020_codes
  {% endset %}

  {% set seed_results = run_query(seed_query) %}

  {% set metadata_query %}
    SELECT DISTINCT 
      "COD_VAR", 
      "LIB_VAR", 
      "COD_MOD", 
      {{ nettoyer_modalite_logement('"LIB_MOD"') }} AS "LIB_MOD"
      FROM {{ source("meta", "logement_2020_variables" ) }}
  {% endset %}

  {% set metadata_results = run_query(metadata_query) %}

  SELECT
    {% for row in seed_results %}
      
      {% set code_col = row['code_col'] %}
      {% set lib_col = row['lib_col'] %}
      {% set code_ou_libelle_valeurs = row['code_ou_libelle_valeurs'] %}
            
      {% if code_ou_libelle_valeurs == 'CODE' %}
        "{{ code_col }}" as "{{ lib_col }}"
      
      {% else %}
        CASE "{{ code_col }}"
          {% for meta_row in metadata_results | selectattr("COD_VAR", "equalto", code_col) %}
            WHEN '{{ meta_row['COD_MOD'] }}' THEN '{{ meta_row['LIB_MOD'] }}'
          {% endfor %}
        END as "{{ lib_col }}"
      
      {% endif %}
      
      {% if not loop.last %}, {% endif %}
    {% endfor %}
  FROM logement
{% endmacro %}