Welcome to your megadata project!

### mega_open_data

### create the environment
python3 -m venv dbt-env  
### activate the environment for Mac and Linux OR
source dbt-env/bin/activate
### install requirements
pip install --upgrade pip
pip install -r requirements.txt


### Instantiate connection to postgres
Note that profile-directory is specified so python can access and use DB infos in profile.yml file

- dbt init --profiles-dir .
- dbt debug


### Extract data (cvs) from sources and upload it to DB
pytbon -m extract

### Using the starter project

Try running the following commands:
- dbt run
- dbt test
