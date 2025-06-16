{{ config(materialized='table') }}

{% set annees = range(2016, 2017) %}

{% if execute %}
    {% set sql %}
        SELECT champ_insee, clef_json, base_source
        FROM {{ source('sources', 'champs_categorises') }}
        WHERE categorie = 'demographie'
    {% endset %}
    {% set champs_raw_table = run_query(sql) %}
    {% set champs_raw = champs_raw_table.rows | list %}
{% else %}
    {% set champs_raw = [] %}
{% endif %}

{% set pop_champs = [] %}
{% set fam_champs = [] %}
{% set seen_pop = [] %}
{% set seen_fam = [] %}
{% for row in champs_raw %}
    {% set clef   = row[1] %}
    {% set record = {'champ_insee': row[0], 'clef_json': clef} %}

    {% if row[2] == 'rp_population' and clef not in seen_pop %}
        {% do pop_champs.append(record) %}
        {% do seen_pop.append(clef) %}
    {% elif row[2] == 'rp_familles_menages' and clef not in seen_fam %}
        {% do fam_champs.append(record) %}
        {% do seen_fam.append(clef) %}
    {% endif %}
{% endfor %}
{{ log('→ pop_champs : ' ~ (pop_champs | length) ~ '  |  fam_champs : ' ~ (fam_champs | length), info=True) }}

{% if execute %}
    {% set cols_by_alias = {} %}

    {% for annee in annees %}
        {% set alias  = 'sp' ~ annee %}
        {% set src    = source('sources', 'base_cc_evol_struct_pop_' ~ annee) %}
        {% set schema = src.schema %}
        {% set table  = src.identifier %}
        {% set sql_cols %}
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = '{{ schema }}'
              AND table_name   = '{{ table }}'
        {% endset %}
        {% set table_cols = run_query(sql_cols).rows | map(attribute=0) | list %}
        {{ log('→ columns trouvées pour ' ~ alias ~ ' : ' ~ (table_cols | length), info=True) }}
        {% do cols_by_alias.update({ alias: table_cols }) %}

        {% set alias  = 'fm' ~ annee %}
        {% set src    = source('sources', 'base_cc_coupl_fam_men_' ~ annee) %}
        {% set schema = src.schema %}
        {% set table  = src.identifier %}
        {% set sql_cols %}
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = '{{ schema }}'
              AND table_name   = '{{ table }}'
        {% endset %}
        {% set table_cols = run_query(sql_cols).rows | map(attribute=0) | list %}
        {{ log('→ columns trouvées pour ' ~ alias ~ ' : ' ~ (table_cols | length), info=True) }}
        {% do cols_by_alias.update({ alias: table_cols }) %}
    {% endfor %}
{% else %}
    {% set cols_by_alias = {} %}
{% endif %}

with
{% for annee in annees %}
struct_pop_{{ annee }} as (
    select
        lpad(cast("CODGEO" as text), 5, '0') as code_commune,
        {{ generate_demographie_columns_year(pop_champs, annee, 'sp' ~ annee) }}
    from {{ source('sources', 'base_cc_evol_struct_pop_' ~ annee) }} as sp{{ annee }}
),
{% endfor %}

{% for annee in annees %}
fam_men_{{ annee }} as (
    select
        lpad(cast("CODGEO" as text), 5, '0') as code_commune,
        {{ generate_demographie_columns_year(fam_champs, annee, 'fm' ~ annee) }}
    from {{ source('sources', 'base_cc_coupl_fam_men_' ~ annee) }} as fm{{ annee }}
){% if not loop.last %},{% endif %}
{% endfor %}

, rp_population as (
    select * from struct_pop_2016
    {% for annee in annees if annee != 2016 %}
        full outer join struct_pop_{{ annee }} using (code_commune)
    {% endfor %}
)

, rp_familles_menages as (
    select * from fam_men_2016
    {% for annee in annees if annee != 2016 %}
        full outer join fam_men_{{ annee }} using (code_commune)
    {% endfor %}
)

, cog_communes as (
    select
        code as code_commune,
        nom as nom_commune,
        departement as code_departement,
        region as code_region
    from {{ source('sources', 'cog_communes') }}
)

select
    coalesce(rp_population.code_commune, rp_familles_menages.code_commune) as code_commune,
    -- Ajout des informations des communes
    cc.nom_commune,
    cc.code_departement,
    cc.code_region,

    -- Colonnes Population 2016‑2021
    {% for annee in annees %}
        {{ generate_demographie_columns_year(pop_champs, annee, 'rp_population') }}{% if not loop.last %},{% endif %}
    {% endfor %},

    -- Colonnes Familles/Ménages 2016‑2021
    {% for annee in annees %}
        {{ generate_demographie_columns_year(fam_champs, annee, 'rp_familles_menages') }}{% if not loop.last %},{% endif %}
    {% endfor %}

from rp_population
full outer join rp_familles_menages using (code_commune)
left join cog_communes cc using (code_commune)