-- Auto-generated model for union of millesimes (depends_on block cannot be generated dynamically in a model interation)


-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2014') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2015') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2016') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2017') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2018') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2019') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2020') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2021') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2022') }}
-- depends_on: {{ ref('mutations_foncieres_enrichies_dvf_2023') }}
{%- set millesimes = ['2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023'] -%}

{{ log("Millesimes retrieved: " ~ millesimes, info=True) }}

{{
    config(
        materialized='table'
    ) 
}}

{% for millesime in millesimes %}
    {{ log("Millesimes retrieved: " ~ millesime, info=True) }}

    SELECT *
    FROM {{ ref('mutations_foncieres_enrichies_dvf_' ~ millesime) }}

    {% if not loop.last %}
    UNION ALL
    {% endif %}
{% endfor %}
    