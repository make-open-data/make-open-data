-- Vérifier que certaines quantités sont conformes par rapport aux dossier de l'INSEE
-- Par exemple Montpellier, code commune 34172

select 
	status_conjugal_pr__celibataire / (nombre_de_logements - status_conjugal_pr__hors_residence_principale) as proportions_celibataires,
	status_conjugal_pr__divorce_e / (nombre_de_logements - status_conjugal_pr__hors_residence_principale) as proportions_divorce,
	status_conjugal_pr__en_concubinage_ou_union_libre / (nombre_de_logements - status_conjugal_pr__hors_residence_principale) as proportions_concubinage_union_libre,
	status_conjugal_pr__marie_e / (nombre_de_logements - status_conjugal_pr__hors_residence_principale) as proportions_marie,
	status_conjugal_pr__pacse_e / (nombre_de_logements - status_conjugal_pr__hors_residence_principale) as proportions_pacse,
	status_conjugal_pr__veuf_veuve / (nombre_de_logements - status_conjugal_pr__hors_residence_principale) as proportions_veuf
from {{ ref('aggreger_demographie_communes') }}
where code_commune_insee = '34172'

-- proportions_celibataires, proportions_divorce, proportions_concubinage_union_libre, proportions_marie, proportions_pacse, proportions_veuf
-- 0.45271001407013124149	0.11121578101415645350	0.10832617037363749454	0.23182251308921670739	0.03850035728419874230	0.05742516416865936078

-- Semblables aux chiffres de l'INSEE pour Montpellier 
-- FAMG4 : https://www.insee.fr/fr/statistiques/2011101?geo=COM-34172#consulter-sommaire

-- Ici hypothèse qu'un ménage = un logement hors résidence de grandeur. Pas forcément le cas.
-- A appronfondir : https://www.insee.fr/fr/information/2383177 
