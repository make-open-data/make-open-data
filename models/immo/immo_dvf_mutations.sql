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

{{ config(materialized='table') }}

WITH filtered_dvf AS (
    SELECT 
        id_mutation,
        valeur_fonciere,
        longitude,
        latitude,
        nombre_pieces_principales,
        surface_reelle_bati,
        type_local,
        LPAD(CAST(code_postal AS TEXT), 5, '0') as code_postal,
        code_commune
    FROM 
        sources.dvf_2023
    WHERE 
        EXISTS (
            SELECT 1
            FROM sources.dvf_2023 d1
            WHERE d1.id_mutation = sources.dvf_2023.id_mutation AND d1.type_local IN ('Appartement', 'Maison')
        ) AND
        NOT EXISTS (
            SELECT 1
            FROM sources.dvf_2023 d2
            WHERE d2.id_mutation = sources.dvf_2023.id_mutation AND d2.nature_mutation != 'Vente'
        )
),
sums AS (
    SELECT 
        id_mutation,
        SUM(surface_reelle_bati) AS total_surface,
        SUM(nombre_pieces_principales) AS total_pieces
    FROM 
        filtered_dvf
    GROUP BY 
        id_mutation
),

ranked_dvf AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY id_mutation
            ORDER BY 
                CASE WHEN type_local = 'Maison' THEN 1
                     WHEN type_local = 'Appartement' THEN 2
                     ELSE 3
                END,
                surface_reelle_bati DESC
        ) AS rn
    FROM 
        filtered_dvf
)

SELECT 
    r.id_mutation,
    r.valeur_fonciere,
    r.longitude,
    r.latitude,
    s.total_pieces,
    s.total_surface,
    r.type_local,
    r.code_postal,
    r.code_commune
FROM 
    ranked_dvf r
JOIN 
    sums s ON r.id_mutation = s.id_mutation
WHERE 
    r.rn = 1