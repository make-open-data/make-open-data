import os
import subprocess
from tempfile import NamedTemporaryFile
import shutil

import pandas as pd
import geopandas as gpd
from sqlalchemy import create_engine
import psycopg





POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_HOST = os.getenv('POSTGRES_HOST')
POSTGRES_PORT = os.getenv('POSTGRES_PORT')
POSTGRES_DB = os.getenv('POSTGRES_DB')




def list_tables_in_pg(storage_to_pg):

    CONNECTION = psycopg.connect(host=POSTGRES_HOST, 
                             port=POSTGRES_PORT, 
                             dbname=POSTGRES_DB, 
                             user=POSTGRES_USER, 
                             password=POSTGRES_PASSWORD)
    CURSOR = CONNECTION.cursor()

    existing_schemas_list = list(set([data['db_schema'] for data in storage_to_pg.values()]))
    existing_schemas_str = ', '.join(f"'{schema}'" for schema in existing_schemas_list)
    CURSOR.execute(f"""
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema in ({existing_schemas_str})
    """)
    existing_tables_list = CURSOR.fetchall()

    CURSOR.close()
    CONNECTION.close()

    return [existing_table[0] for  existing_table in existing_tables_list]

    

def load_file_from_storage(tmpfile_csv_path, data_infos):

    storage_path = data_infos["storage_path"]
    
    if data_infos['file_format'] == 'csv':
        subprocess.run(['curl', '-o', tmpfile_csv_path, storage_path], check=True)

    elif data_infos['file_format'] == 'json':
        with NamedTemporaryFile(suffix='.json', delete=True) as json_tmpfile:
            json_tmpfilename = json_tmpfile.name
        subprocess.run(['curl', '-o', json_tmpfilename, storage_path], check=True)
        data = pd.read_json(json_tmpfilename)
        data.to_csv(tmpfile_csv_path, index=False)
    else:
        raise ValueError(f"Unsupported file extension in path: {storage_path}")

    return tmpfile_csv_path

def get_columns_from_csv(file_path, delimiter):
    """
    Read first line to get columns names
    """
    df = pd.read_csv(file_path, sep=delimiter, nrows=1)
    return df.columns.tolist()


def load_file_to_pg(tmpfile_csv_path:str, pg_table:str, data_infos):
    """
    Load a temporary csv file and feed it to the DB as a new table.

    arguments:
    tmpfile_csv_path -- path to the temporary file created by load_file_from_storage
    pg_table -- name of the table to create
    data_infos -- dict of metadata, loaded from storage_to_pg.yml
    """

    db_schema = data_infos["db_schema"]
    delimiter = data_infos["csv_delimiter"] if data_infos["file_format"] == 'csv' else ','

    file_columns = get_columns_from_csv(tmpfile_csv_path, delimiter)
    file_columns_str = ', '.join(f'"{col}"' for col in file_columns)


    CONNECTION = psycopg.connect(host=POSTGRES_HOST, 
                                port=POSTGRES_PORT, 
                                dbname=POSTGRES_DB, 
                                user=POSTGRES_USER, 
                                password=POSTGRES_PASSWORD)
    CURSOR = CONNECTION.cursor()


    CURSOR.execute(f"""
        CREATE SCHEMA IF NOT EXISTS "{db_schema}";
    """)
    CONNECTION.commit()


    CURSOR.execute(f"""
        DROP TABLE IF EXISTS "{db_schema}"."{pg_table}" CASCADE;
    """)
    CONNECTION.commit()



    CURSOR.execute(f"""
        CREATE TABLE "{db_schema}"."{pg_table}" (
            {', '.join(f'"{col}" text' for col in file_columns)}
        );
    """)
    CONNECTION.commit()

    
    with open(tmpfile_csv_path, 'r') as f:
        with CURSOR.copy(f"COPY {db_schema}.{pg_table}({file_columns_str}) FROM STDIN CSV HEADER DELIMITER '{delimiter}' ") as copy:
            copy.write(f.read())
    CONNECTION.commit()
    
    CURSOR.close()
    CONNECTION.close()


def load_shapefile_from_storage(tmpfolder_name, tmpzip_name, data_infos):
    
    storage_path = data_infos["storage_path"]
    
    subprocess.run(['curl', '-o', tmpzip_name, storage_path], check=True)
    shutil.unpack_archive(tmpzip_name, tmpfolder_name)



def load_shapefile_to_pg(tmpfolder_name, pg_table, data_infos):
    shp_file_name = [file_name for file_name in os.listdir(tmpfolder_name) if file_name.endswith('.shp')][0]
    shp_file_path = f'{tmpfolder_name}/{shp_file_name}'

    db_schema = data_infos["db_schema"]

    engine = create_engine(f'postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{POSTGRES_HOST}:{POSTGRES_PORT}/{POSTGRES_DB}')


    shape_file = gpd.read_file(shp_file_path)
    shape_file.to_postgis(pg_table, engine, schema=db_schema, if_exists='replace')




    # TODO: Eviter geopandas, GeoAlchemy2 et sqlalchemy et loader les fichiers avec shp2pgsql
    # Point de bloquage avec shp2pgsql : 
    # - avec shp2pgsql, les fichiers shape (shp, cpg, dbf, etc) doivent être dans le dossier courant, rendant l'utilisation de TemporaryDirectory impoosible
    # - le psql bloque sur ANALYZE
    #subprocess.Popen('shp2pgsql -c -D -I COMMUNE.shp sources.shape_communes > temp.sql', shell=True)
    #subprocess.Popen('psql -f temp.sql postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB', shell=True)