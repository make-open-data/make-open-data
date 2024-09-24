"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
from pathlib import Path
from tempfile import NamedTemporaryFile


from load.loaders import load_from_storage, load_to_pg, list_tables_in_pg

STORAGE_TO_PG = "storage_to_pg.yml"

if __name__ == "__main__":

    with open(Path(os.path.dirname(__file__)) / STORAGE_TO_PG, "r") as ymlfile:
        storage_to_pg = yaml.safe_load(ymlfile)

    tables_in_pg_list = list_tables_in_pg(storage_to_pg)

    for pg_table, data_infos in storage_to_pg.items():
        
        if pg_table in tables_in_pg_list:
            print(f"Table already exist: {pg_table}")
        
        else:
            
            with NamedTemporaryFile(suffix='.csv', delete=True) as tmpfile:
                tmpfile_csv_path = tmpfile.name
                
                print(f"Loading from storage: {pg_table}")
                load_from_storage(tmpfile_csv_path, data_infos)
                
                print(f"Loading to PG: {pg_table}")
                load_to_pg(tmpfile_csv_path, pg_table, data_infos)

                print("***")