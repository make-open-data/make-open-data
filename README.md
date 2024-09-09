# Bienvenue sur Make Open Data.

Ici pour la [documentation complète](https://make-open-data.fr/).

## Intégrez les données libres en France à votre Base De Données.

Make Open Data est un repo de code ouvert qui :
- *Extrait* les fichiers sources (data.gouv, INSEE, Etalab, etc.) les plus adaptés et les récents ; 
- *Transforme* ces données selon des règles transparentes et le moins irreversibles possibles ;
- *Stocke* ces données dans une base de données PostgreSQL (avec PostGIS) ;
- *Teste* des présuposés sur ces données. Un prix par transaction immobilières sur DVF par exemple.



## Déploiement avec GitHub Actions

- Foucher (*fork*) le projet dans un nouveau Repo [ici](https://github.com/make-open-data/make-open-data/fork)  

- Renseigner les clés d'une BDD Postgres dans le Cloud 

- Executer le workflow "Manually Deploy Data in a Postgres Database" 

- Les tables sources et préparées sont disponibles dans la BDD


## Dépoilement sur une machine

Idéal pour déployer les nouvelles tables de données publiques sans tracas une BDD Postgres hébérgée dans le cloud.

- Cloner le repo

```
git clone git@github.com:make-open-data/make-open-data.git
``` 
- Installer et activer un envirnoment virtuel (pip3 install important)


```
python3.11 -m venv dbt-env 
source dbt-env/bin/activate
python3 -m pip install --upgrade pip wheel setuptools
pip3 install -r requirements.txt
``` 

-- Vérifier que dbt-duckdb est bien installé

```
dbt --version
```

- A faire une fois : installer les extensions PostGis et unaccent et vérifier

```
psql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB
CREATE EXTENSION postgis;  
SELECT PostGIS_Version();
CREATE EXTENSION unaccent;

```

- Connecter DBT à la base de données

```
export DBT_PROFILES_DIR=.  
dbt debug
dbt deps
``` 

- Extraire les données des sources à la base de données

```
python -m extract
```

- Réaliser et tester les transformations pour avoir obtenir les tables finales

```
dbt seed
dbt run
dbt test
``` 

- Les tables sources et préparées sont disponibles dans la BDD
