# Bienvenue sur Make Open Data.

Ici pour la [documentation complète](https://make-open-data.fr/).

## Intégrez les données libres en France à votre Base De Données.

Make Open Data est un repo de code ouvert qui :
- *Extrait* les fichiers sources (data.gouv, INSEE, Etalab, etc.) les plus adaptés et les récents ; 
- *Transforme* ces données selon des règles transparentes et le moins irréversibles possibles ;
- *Stocke* ces données dans une base de données PostgreSQL (avec PostGIS) ;
- *Teste* des présupposés sur ces données. Un prix par transaction immobilière sur DVF par exemple.



## Déploiement avec GitHub Actions

- Foucher (*fork*) le projet dans un nouveau Repo [ici](https://github.com/make-open-data/make-open-data/fork)  

- Renseigner les clés d'une BDD Postgres dans le Cloud 

- Exécuter le workflow "Manually Deploy Data in a Postgres Database" 

- Les tables sources et préparées sont disponibles dans la BDD


## Déploiement sur une machine

Idéal pour déployer les nouvelles tables de données publiques sans tracas une BDD Postgres hébérgée dans le cloud.

- Cloner le repo

```
git clone git@github.com:make-open-data/make-open-data.git
``` 
- Installer et activer un environnement virtuel


```
python3.11 -m venv dbt-env 
source dbt-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
``` 



- Exporter les clés d'une instance PostgreSQL avec l'extention PostGIS de 10 GB min

```
export POSTGRES_USER=<YOUR_POSTGRES_USER>  
export POSTGRES_PASSWORD=<YOUR_POSTGRES_PASSWORD> 
export POSTGRES_HOST=<YOUR_POSTGRES_HOST> 
export POSTGRES_PORT=<YOUR_POSTGRES_PORT>  
export POSTGRES_DB=<YOUR_POSTGRES_DB>
``` 

- A faire une fois : installer les extensions PostGis et unaccent et vérifier

```
psql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB
CREATE EXTENSION postgis;  
CREATE EXTENSION unaccent;
```

- Extraire les données sources dans le schema `sources`:

```
python -m extract
```

Etape temporaire : 
    - Une extraction automatique ne vaut pas le coup étant donné la diversité des fichiers sources (zip, csv, json, 7z, etc) et la mise à jour non fréquente des sources ;
    - Une solution du type Lakehouse est en cours d'analyse (`SELECT * FROM "red_parquet(<URL>.parquet)"`)


- Connecter DBT à la base de données

```
export DBT_PROFILES_DIR=.  
dbt debug
dbt deps
``` 


- Réaliser et tester les transformations pour obtenir les tables finales

```
dbt seed
dbt run
dbt test
``` 

- Les tables sources et préparées sont disponibles dans la BDD
