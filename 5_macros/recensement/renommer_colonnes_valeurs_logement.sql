{% macro renommer_colonnes_values_logement(logement, theme) %}    

    {% set listes_colonnes_codes_libelle_liste_liste = lister_colonnes_modaliter_libelles(theme) %}

    {% set colonnes_liste = listes_colonnes_codes_libelle_liste_liste[0] %}
    {% set modalites_liste_de_liste = listes_colonnes_codes_libelle_liste_liste[1] %}
    {% set libelle_liste_de_liste = listes_colonnes_codes_libelle_liste_liste[2] %}


    select 
        CASE
            WHEN "ARM" != 'ZZZZZ' THEN "ARM"
            ELSE "COMMUNE" 
        END AS code_commune_insee,
        "CATL",
        CASE 
		    WHEN "IRIS" = 'ZZZZZZZZZ' THEN CONCAT("COMMUNE", '0000')
		    ELSE "IRIS"
	    END as code_iris,
        {% for colonne_codee, modalite_liste, libelle_liste in  zip(colonnes_liste, modalites_liste_de_liste, libelle_liste_de_liste) %}
            CASE
                {% for modalite, libelle in zip(modalite_liste, libelle_liste) %}
                    when LPAD(CAST("{{ colonne_codee }}" AS TEXT), 3, '0') = '{{ modalite }}' then '{{ libelle }}'
                {% endfor %}
            END AS "{{ colonne_codee }}",
        {% endfor %}
        CAST(CAST("IPONDL" AS NUMERIC) AS INT) AS poids_du_logement
    
    FROM 
        logement

{% endmacro %}
