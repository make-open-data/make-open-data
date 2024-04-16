Welcome to your mega open data project!

### What do you need ?

* PostgreSQL database with 10 GB min
  * Local
  * Digital Ocean
  * Supabase

* PostgreSQL PostGis extenstion

`psql postgresql://{user}:{password}@{host}:{port}/{database}`  
`CREATE EXTENSION postgis;`  
`SELECT PostGIS_Version();`


### create the environment
`python3 -m venv dbt-env`  
### activate the environment for Mac and Linux OR
`source dbt-env/bin/activate`  
### install requirements
`pip install --upgrade pip`  
`pip install -r requirements.txt`  

### Instantiate connection to postgres

`export DBT_PROFILES_DIR=.`
`dbt debug`

### Extract data (cvs) from sources and upload it to DB
`pytbon -m extract`

### Using the starter project

Try running the following commands:
`dbt run`  
`dbt test`
