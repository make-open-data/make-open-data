"""
This module host loaders to safely download sources files and upload csv to database
"""
import os
import subprocess
import zipfile
from tempfile import NamedTemporaryFile

import pandas as pd
import psycopg




# Database connection parameters
user = os.getenv('POSTGRES_USER')
password = os.getenv('POSTGRES_PASSWORD')
host = os.getenv('POSTGRES_HOST')
port = os.getenv('POSTGRES_PORT')
database = os.getenv('POSTGRES_DB')


extract_schema_name = 'sources'

def read_from_source(tmpfile_csv_path,sources_infos ):

    source_path = sources_infos["source_url"]
    
    if source_path.endswith('.csv'):
        subprocess.run(['curl', '-o', tmpfile_csv_path, source_path], check=True)

    elif source_path.endswith('.json'):
        with NamedTemporaryFile(suffix='.json', delete=True) as json_tmpfile:
            subprocess.run(['curl', '-o', json_tmpfile.name, source_path], check=True)
            data = pd.read_json(json_tmpfile.name)
            data.to_csv(tmpfile_csv_path, index=False)

    elif source_path.endswith('.gz'):
        with NamedTemporaryFile(suffix='.gz', delete=True) as gz_tmpfile:
            subprocess.run(['curl', '-o', gz_tmpfile.name, source_path], check=True)
            with open(tmpfile_csv_path, 'w') as f:
                subprocess.run(['gunzip', '-c', gz_tmpfile.name], stdout=f, check=True)

    elif source_path.endswith('.zip'):
        with NamedTemporaryFile(suffix='.zip', delete=True) as zip_tmpfile:
            subprocess.run(['curl', '-o', zip_tmpfile.name, source_path], check=True)
            with zipfile.ZipFile(zip_tmpfile.name, 'r') as z:
                csv_file = next((name for name in z.namelist() if name.endswith('.csv')), None)
                if csv_file is None:
                    raise ValueError('No CSV file found in the zip file')
                with z.open(csv_file) as f, open(tmpfile_csv_path, 'w') as out_f:
                    out_f.write(f.read().decode('utf-8'))

    else:
        raise ValueError(f"Unsupported file extension in path: {source_path}")

    return tmpfile_csv_path

def get_columns_from_csv(file_path, delimiter):
    # Read only the first row of the CSV file
    df = pd.read_csv(file_path, sep=delimiter, nrows=1)
    # Return the column names
    return df.columns.tolist()


def upload_dataframe_to_table(tmpfile_csv_path, table_name, source_infos):
    """
    Upload a dataframe to a table in the database
    https://cboyer.github.io/developpement/postgres-parquet/
    """
    try:
        # Connect to the PostgreSQL database
        connection = psycopg.connect(host=host, 
                                     port=port, 
                                     dbname=database, 
                                     user=user, 
                                     password=password)
        cursor = connection.cursor()

        # Create the schema if it doesn't exist
        cursor.execute(f"""
            CREATE SCHEMA IF NOT EXISTS "{extract_schema_name}";
        """)
        connection.commit()

        # Drop the table if it exists
        cursor.execute(f"""
            DROP TABLE IF EXISTS "{extract_schema_name}"."{table_name}";
        """)
        connection.commit()

        delimiter = source_infos["source_csv_delimiter"]
        columns = get_columns_from_csv(tmpfile_csv_path, delimiter)

        # Create the table
        cursor.execute(f"""
            CREATE TABLE "{extract_schema_name}"."{table_name}" (
                {', '.join(f'"{col}" text' for col in columns)}
            );
        """)
        connection.commit()

        columns_str = ', '.join(f'"{col}"' for col in columns)
        # Copy the data from the temporary file to the table
        with open(tmpfile_csv_path, 'r') as f:
            with cursor.copy(f"COPY {extract_schema_name}.{table_name}({columns_str}) FROM STDIN CSV HEADER DELIMITER '{delimiter}' ") as copy:
                copy.write(f.read())
        connection.commit()
        
        cursor.close()
        connection.close()

    except Exception as e:
        print(e)
        if 'connection' in locals():
            connection.rollback()
            connection.close()
        raise