Welcome to your mega open data project!

### What do you need ?

PostgreSQL database with 10 GB min
  * Local
  * Digital Ocean
  * Supabase




### create the environment
`python3 -m venv dbt-env`  
### activate the environment for Mac and Linux OR
`source dbt-env/bin/activate`  
### install requirements
`pip install --upgrade pip`  
`pip install -r requirements.txt`  

### Set database env variable (used by profile.yml and extract)

`export POSTGRES_USER=<YOUR_POSTGRES_USER>`
`export POSTGRES_PASSWORD=<YOUR_POSTGRES_PASSWORD>`
`export POSTGRES_HOST=<YOUR_POSTGRES_HOST>`
`export POSTGRES_PORT=<YOUR_POSTGRES_PORT>`
`export POSTGRES_DB=<YOUR_POSTGRES_DB>`

## Set PostgreSQL PostGis extenstion

`psql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB`  
`CREATE EXTENSION postgis;`  
`SELECT PostGIS_Version();`

### Instantiate connection to postgres
`export DBT_PROFILES_DIR=.`
`dbt debug`

### Extract data (cvs) from sources and upload it to DB
`pytnon -m extract`

### Run 

`dbt run`  
`dbt test`
