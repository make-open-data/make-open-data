{% macro renommer_colonnes_logement(logement) %}
  
  {% set seed_query %}
    SELECT DISTINCT 
      code_col, 
      lib_col
    FROM {{ ref('logement_2020_codes') }} as logement_2020_codes
  {% endset %}

  {% set seed_results = run_query(seed_query) %}

  SELECT
    {% for row in seed_results %}
      {% set code_col = row['code_col'] %}
      {% set lib_col = row['lib_col'] %}
      
      "{{ code_col }}" as "{{ lib_col }}"
      {% if not loop.last %}, {% endif %}
    {% endfor %}
  FROM 
      logement

{% endmacro %}