-- Filtres nature transaction et nature bien :
-- Il convient aussi de garder que les vente (explure les VEFA et les échanges)
-- Et que les transactions qui concernent au moins un appartement et les maisons

-- Filtres sur les surfaces et trautement des pièces :
-- Il convient de garder que les transactions qui concernent des biens de plus de 9m2 
-- Le nombre de pièces est souvent mal renseigné, il convient de le corriger en fonction de la surface

-- Filtres sur les prix :
-- Il convient de garder que les transactions dont le prix au metre carré n'est pas 50% de plus que ses 10 plus proches voisins

-- Données par mutation : 
-- Les données DVF sont initilement présentées sous forme d'une ligne par mutation (transaction)
-- Une mutation peut concerner plusieurs biens
-- Le prix est le prix total de la mutation, il apparait sur les biens concernés

{{ 
    config(
        materialized='table',
        schema='intermediaires',
        post_hook=[
            "CREATE INDEX IF NOT EXISTS geopoint_index ON {{ this }} USING GIST(geopoint);",
        ]
    ) 
}}

{% set liste_des_millesimes = ['2014', '2015', '2016', '2017', '2018', '2019', 
                               '2020', '2021', '2022', '2023', '2024',] %}

{% for millesime in liste_des_millesimes %}
    select *
    from ({{ preparer_dvf_biens_immobilier(millesime) }})
    {% if not loop.last %} union {% endif %}
{% endfor %}
