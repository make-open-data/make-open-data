"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
from pathlib import Path
from tempfile import NamedTemporaryFile


from extract.loaders import read_from_source, upload_dataframe_to_table

SOURCES_PATH = "sources.yml"

def filter_sources_by_tag(sources, tag):
    return {label: info for label, info in sources['sources'].items() if tag in info.get('tags', [])}


if __name__ == "__main__":

  # Load sources from YAML file
    with open(Path(os.path.dirname(__file__)) / SOURCES_PATH, "r") as ymlfile:
        sources = yaml.safe_load(ymlfile)

    parser = argparse.ArgumentParser(description="Run extraction of data from sources.")
    parser.add_argument('--tag', help="Extract only sources tagged with the specified tag")
    args = parser.parse_args()

    if args.tag:
        # Filter sources by the specified tag
        sources = filter_sources_by_tag(sources, args.tag)

    for source_label, source_infos in sources.items():
        with NamedTemporaryFile(suffix='.csv', delete=True) as tmpfile:
            tmpfile_csv_path = tmpfile.name
            read_from_source(tmpfile_csv_path, source_infos)
            upload_dataframe_to_table(tmpfile_csv_path, source_label, source_infos)