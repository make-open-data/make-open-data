{% docs __overview__ %}
# Make Open Data 

### Des données publiques exploitables déployées sur une BDD Postgres/PostGIS accessibles depuis l'outil de votre choix.

- Son déploiement, son utilisation ou prendre contact : https://make-open-data.fr/ 
- Un ticket, une contribution ou une étoile pour nous soutenir : https://github.com/make-open-data/make-open-data/  

---
### Liste non exhaustive et non définitive des tables préparées par Make Open Data : 


- [commune_centroid_poste](/#!/model/model.makeopendata.commune_centroid_poste): table de correspondance une commune pour chaque code postal : si N communes pour un code postal, on prend la commune la plus centrale (centroîd)
- [infos_communes](/#!/model/model.makeopendata.infos_communes) : informations sur les communes : codes, nom, population, localisation et contour géographique.
- [infos_iris](/#!/model/model.makeopendata.infos_iris) : informations sur les iris : codes, nom, localisation et contour géographique.
- [infos_poste](/#!/model/model.makeopendata.infos_poste) : informations sur les codes postaux


- [demographie_communes](/#!/model/model.makeopendata.demographie_communes) : Nombre de ménages par structure démographique (âge, enfants, status matrimonial, etc) par commune
- [demographie_iris](/#!/model/model.makeopendata.demographie_iris) : Nombre de ménages par structure démographie (âge, enfants, status matrimonial, etc) par iris


- [activite_communes](/#!/model/model.makeopendata.activite_communes) : Nombre de ménages par nature d'activité (scolarisation, travail, type de contrat, etc) par commune
- [activite_iris](/#!/model/model.makeopendata.activite_iris) : Nombre de ménages par nature d'activité (scolarisation, travail, type de contrat, etc) par iris


- [habitat_communes](/#!/model/model.makeopendata.habitat_communes) : Nombre de ménages par caractéristique de l'habitat (emménagement, statut d'occupation, combustible, etc) par commune
- [habitat_iris](/#!/model/model.makeopendata.habitat_iris) : Nombre de ménages par caractéristique de l'habitat (emménagement, statut d'occupation, combustible, etc) par iris


- [mobilite_communes](/#!/model/model.makeopendata.mobilite_communes) : Nombre de ménages par nature de mobilité (lieu de travail vs domicile, nombre de véhicules, mode transport, etc) par commune
- [mobilite_iris](/#!/model/model.makeopendata.mobilite_iris) : Nombre de ménages par nature de mobilité (lieu domicile année précédente, lieu de travail vs domicile, nombre de véhicules, mode transport, etc) par iris


- [revenu_commune](/#!/model/model.makeopendata.revenu_commune) : Indicateur de revenus (médiane niveau de vie, déciles, pauvreté par tranche d'âge) et nature de revenu (part revenu activité, indemnités chômage, patrimoine, etc) par commune


- [professionnels_sante_departement](/#!/model/model.makeopendata.professionnels_sante_departement) : Nombre de professionnels de santés médecins (chirurgiens, dermatologues, dentistes, etc) et para-médical (infirmiers, kiné, etc) par département en 2022.


- [ventes_immobilieres_enrichies](/#!/model/model.makeopendata.ventes_immobilieres_enrichies) : Liste des transactions immobilières à l'échelle de la transaction (une ligne par transaction) avec leurs prix, surfaces, type de bien, le prix moyen des plus proches voisins, etc. Pour l'années 2023.


## Notes 

Sauf mention contraire, toutes les données sont millésimées au Code Officiel Géographique de 2024.


{% enddocs %}