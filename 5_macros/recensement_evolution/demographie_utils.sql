{% macro safe_demographie_col_expr(champ_insee, clef_json, annee, alias) %}
    {% set yy = (annee|string)[-2:] %}

    {# CAS 1 – alias agrégé : colonne déjà nommée "YYYY_clef_json" #}
    {% if alias.startswith('rp_') %}
        {{ alias }}."{{ annee }}_{{ clef_json }}" AS "{{ annee }}_{{ clef_json }}"

    {% else %}
        {# CAS 2 – vraie table source spYYYY / fmYYYY #}
        {% set letter = (champ_insee[-1]|upper) if champ_insee.endswith(('_P','_C','_F')) else 'P' %}
        {% set body   = champ_insee[:-2] if champ_insee.endswith(('_P','_C','_F')) else champ_insee %}
        {% set col_name = letter ~ yy ~ '_' ~ body %}

        {% if execute and (alias.startswith('sp') or alias.startswith('fm')) %}
            {% set tbl = ('base_cc_evol_struct_pop_' if alias.startswith('sp') else 'base_cc_coupl_fam_men_') ~ annee %}
            {% set src = source('sources', tbl) %}
            {% set q_exists %}
                SELECT 1 FROM information_schema.columns
                 WHERE table_schema = '{{ src.schema }}'
                   AND table_name   = '{{ src.identifier }}'
                   AND column_name  = '{{ col_name }}'
                 LIMIT 1
            {% endset %}
            {% set exists = run_query(q_exists).rows | length > 0 %}
        {% else %}
            {% set exists = true %}
        {% endif %}

        {% if not exists %}
            {{ log('⚠️  Colonne absente (' ~ alias ~ '.' ~ col_name ~ ') : remplissage NULL', info=True) }}
            NULL AS "{{ annee }}_{{ clef_json }}"
        {% else %}
            {{ alias }}."{{ col_name }}" AS "{{ annee }}_{{ clef_json }}"
        {% endif %}
    {% endif %}
{% endmacro %}



{% macro generate_demographie_columns_year(champs, annee, alias) %}
    {% set cols = [] %}
    {% for c in champs %}
        {% do cols.append(
            safe_demographie_col_expr(c.champ_insee, c.clef_json, annee, alias)
        ) %}
    {% endfor %}
    {{ cols | join(',\n        ') }}

{% endmacro %}
