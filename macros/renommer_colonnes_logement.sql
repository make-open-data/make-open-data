---https://docs.getdbt.com/guides/using-jinja?step=9

{% macro renommer_colonnes_logement(logement) %}
{% set code_libelle_query %}
  SELECT DISTINCT 
    "COD_VAR" as code_variable,
    "LIB_VAR" as libelle_variable
  FROM meta.logement_2020_variables
{% endset %}

{% set code_libelle_results = run_query(code_libelle_query) %}

{% if execute %}
    {% set code_results = code_libelle_results.columns[0].values() %}
    {% set libelle_results = code_libelle_results.columns[1].values() %}
{% else %}
    {% set code_results = [] %}
    {% set libelle_results = [] %}
{% endif %}

select
  {% for code, libelle in zip(code_results, libelle_results)  %}
    "{{ code }}" as "{{ libelle }}" {% if not loop.last -%} , {% endif -%}
  {% endfor %}

from logement

{% endmacro %}