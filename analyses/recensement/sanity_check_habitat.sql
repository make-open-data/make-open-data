-- Vérifier que certaines quantités sont conformes par rapport aux dossier de l'INSEE
-- Par exemple Montpellier, code commune 34172

select 
	nombre_de_logements,
	type_logement__appartement,
	type_logement__maison
from {{ ref('habitat_communes') }}
where code_commune_insee = '34172'

-- Nombre_de_logements, type_logement__appartement,type_logement__maison
-- 177110.492716640209757	153388.053005437629254	20926.742388919034265


-- Les mêmes que les chiffres de l'INSEE pour Montpellier
-- https://www.insee.fr/fr/statistiques/2011101?geo=COM-34172#consulter-sommaire