"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
from pathlib import Path
from tempfile import NamedTemporaryFile


from extract.loaders import read_from_source, upload_dataframe_to_table

SOURCES_PATH = "sources.yml"

if __name__ == "__main__":

    with open(Path(os.path.dirname(__file__)) / SOURCES_PATH, "r") as ymlfile:
        sources = yaml.safe_load(ymlfile)

    for source_label, source_infos in sources.items():
        with NamedTemporaryFile(suffix='.csv', delete=True) as tmpfile:
            tmpfile_csv_path = tmpfile.name
            read_from_source(tmpfile_csv_path, source_infos["source_url"])
            upload_dataframe_to_table(tmpfile_csv_path, source_label)