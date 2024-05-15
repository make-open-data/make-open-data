# Bienvenue sur Make Open Data.

Ici pour la [documentation complète](https://make-open-data.fr/).

## Intégrez les données libres en France à votre Base De Données.

Make Open Data est un repo de code ouvert qui :
- *Extrait* les fichiers sources (data.gouv, INSEE, Etalab, etc.) les plus adaptés et les récents ; 
- *Transforme* ces données selon des règles transparentes et le moins irreversibles possibles ;
- *Stocke* ces données dans une base de données PostgreSQL (avec PostGIS) ;
- *Teste* des présuposés sur ces données. Un prix par transaction immobilières sur DVF par exemple.


## Déploiement rapide :

- Cloner le repo

```
git clone git@github.com:make-open-data/make-open-data.git
``` 
- Installer et activer un envirnoment virtuel


```
python3 -m venv dbt-env 
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

- Connecter DBT à la base de données

```
export DBT_PROFILES_DIR=.  
dbt debug
``` 

- Extraire les données des sources à la base de données

```
python -m extract
```

- Réaliser et tester les transformations pour avoir obtenir les tables finales

```
dbt run
dbt test
``` 

- Utilisez les en production ou branchez votre outils d'analyse.