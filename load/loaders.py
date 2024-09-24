import os
import subprocess
from tempfile import NamedTemporaryFile

import pandas as pd
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

    

def load_from_storage(tmpfile_csv_path, data_infos ):

    storage_path = data_infos["storage_path"]
    
    if storage_path.endswith('.csv') or storage_path.endswith('/csv'):
        subprocess.run(['curl', '-o', tmpfile_csv_path, storage_path], check=True)

    elif storage_path.endswith('.json'):
        with NamedTemporaryFile(suffix='.json', delete=True) as json_tmpfile:
            subprocess.run(['curl', '-o', json_tmpfile.name, storage_path], check=True)
            data = pd.read_json(json_tmpfile.name)
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


def load_to_pg(tmpfile_csv_path, pg_table, data_infos):

    db_schema = data_infos["db_schema"]
    delimiter = data_infos["csv_delimiter"]

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