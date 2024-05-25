"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
import argparse
from pathlib import Path
import gc

from extract.loaders import read_from_source, upload_dataframe_to_table, upload_dataframe_to_storage, read_from_storage

SOURCES_PATH = "sources.yml"

def main(to_store):
    # Load the sources file
    with open(Path(os.path.dirname(__file__)) / SOURCES_PATH, "r") as ymlfile:
        sources = yaml.safe_load(ymlfile)

    for source_label, source_infos in sources.items():
        print(f"Extracting data from {source_label}")
        if to_store:
            data = read_from_source(source_infos["source_url"])
            upload_dataframe_to_storage(data, source_label)
        else:
            data = read_from_storage(source_label)
            upload_dataframe_to_table(data, source_label)
        del data
        gc.collect()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Extract data.')
    parser.add_argument('-to_store', action='store_true', help='Load data from sources to storage')
    args = parser.parse_args()
    main(args.to_store)