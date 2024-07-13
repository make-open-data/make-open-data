"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
import argparse
from pathlib import Path
from tempfile import NamedTemporaryFile

from extract.loaders import read_from_source, upload_dataframe_to_table, check_if_source_exists

SOURCES_PATH = "sources.yml"

def load_sources(file_path):
    with open(file_path, "r") as ymlfile:
        return yaml.safe_load(ymlfile)

def filter_sources_by_tag(sources, tag):
    return {label: info for label, info in sources.items() if tag in info.get('tags', [])}

def main():
    parser = argparse.ArgumentParser(description="Run extraction of data from sources.")
    parser.add_argument('--tag', help="Extract only sources tagged with the specified tag")
    args = parser.parse_args()

    # Load sources from YAML file
    sources = load_sources(Path(os.path.dirname(__file__)) / SOURCES_PATH)

    if args.tag:
        # Filter sources by the specified tag
        sources = filter_sources_by_tag(sources, args.tag)

    for source_label, source_infos in sources.items():
         # Check if the source already exists
        if check_if_source_exists(source_label):
            print(f"Source {source_label} already exists. Skipping...")
            continue

        with NamedTemporaryFile(suffix='.csv', delete=True) as tmpfile:
            tmpfile_csv_path = tmpfile.name
            read_from_source(tmpfile_csv_path, source_infos)
            upload_dataframe_to_table(tmpfile_csv_path, source_label, source_infos)

if __name__ == "__main__":
    main()