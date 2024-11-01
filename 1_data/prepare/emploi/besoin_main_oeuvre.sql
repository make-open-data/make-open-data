{{ 
    config(
        materialized='table',
    ) 
}}

    select a.annee_enquete,
           a.code_metier,a.nom_metier,a.famille_metier,a.libelle_famille_metier,
           a.bassin_emploi,a.nom_bassin_emploi,
           a.departement,a.nom_departement,
           a.code_region,a.nom_region,
           a.nb_projet_recrutement,a.nb_projet_recrutement_difficile,a.nb_projet_recrutement_saisonnier,
           b.contour_departement
      from sources.bmo_2024 a
           join prepare.infos_departements b
             on a.departement = b.code_departement
