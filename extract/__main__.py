"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
from pathlib import Path
import gc

from extract.loaders import safe_read_csv, upload_dataframe_to_table

SOURCES_PATH = "sources.yml"

if __name__ == "__main__":
    # Load the sources file
    with open(Path(os.path.dirname(__file__)) / SOURCES_PATH, "r") as ymlfile:
        sources = yaml.safe_load(ymlfile)

    for source, source_data in sources.items():
        print(f"Extracting data from {source}")
        data = safe_read_csv(source_data["url"])
        upload_dataframe_to_table(data, source)
        del data
        gc.collect()


