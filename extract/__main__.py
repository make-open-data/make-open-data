"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
from pathlib import Path
from tempfile import NamedTemporaryFile


from extract.loaders import read_csv_from_source, read_pg_dump_from_source, upload_csv_to_table, upload_pg_dump_to_table

SOURCES_PATH = "sources.yml"

if __name__ == "__main__":

    with open(Path(os.path.dirname(__file__)) / SOURCES_PATH, "r") as ymlfile:
        sources = yaml.safe_load(ymlfile)

    for source_label, source_infos in sources.items():
        if source_infos["source_type"] == "flat_file":
            with NamedTemporaryFile(suffix='.csv', delete=True) as tmpfile:
                tmpfile_csv_path = tmpfile.name
                read_csv_from_source(tmpfile_csv_path, source_infos)
                upload_csv_to_table(tmpfile_csv_path, source_label, source_infos)
        elif source_infos["source_type"] == "pg_dump":
            with NamedTemporaryFile(suffix='.sql', delete=True) as tmpfile:
                tmpfile_sql_path = tmpfile.name
                read_pg_dump_from_source(tmpfile_sql_path, source_infos)
                upload_pg_dump_to_table(tmpfile_sql_path)
