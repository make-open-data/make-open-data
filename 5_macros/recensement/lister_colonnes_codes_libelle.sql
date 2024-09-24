{% macro lister_colonnes_modaliter_libelles(theme) %}    


      {% set colonnes_modalite_libelle_query %}
        SELECT DISTINCT "COD_VAR", "COD_MOD", libelle_a_afficher_apres_aggregation
        FROM {{ ref('logement_2020_valeurs') }}
        WHERE (theme = '{{ theme }}')
      {% endset %}

      {% set colonnes_modalite_libelle_values = run_query(colonnes_modalite_libelle_query) %}




        -- Colonnes uniques
        {% set colonnes_liste = [] %}

            {% for row in colonnes_modalite_libelle_values %}

                {% if row[0] not in colonnes_liste %}
                    {% do colonnes_liste.append(row[0]) %}
                {% endif %}

            {% endfor %}

        -- Listes de liste de modalites et libelles
        {% set modalites_liste_de_liste = [] %}
        {% set libelle_liste_de_liste = [] %}

        {% for cette_colonne in colonnes_liste %}
            {% set modalites_liste_cette_colonne = [] %}
            {% set libelle_liste_cette_colonne = [] %}

            {% for row in colonnes_modalite_libelle_values %}
                {% if row[0] == cette_colonne %}
                    {% do modalites_liste_cette_colonne.append(row[1]) %}
                    {% do libelle_liste_cette_colonne.append(row[2]) %}
                {% endif %}
            {% endfor %}  

            {% do modalites_liste_de_liste.append(modalites_liste_cette_colonne) %}
            {% do libelle_liste_de_liste.append(libelle_liste_cette_colonne) %}
        {% endfor %}  

      {{ return([colonnes_liste, modalites_liste_de_liste, libelle_liste_de_liste]) }}
{% endmacro %}