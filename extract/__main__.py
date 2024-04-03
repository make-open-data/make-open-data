"""
This module runs extraction of data from the sources defined in the sources.yml file.
"""
import yaml
import os
from pathlib import Path

from extract.loaders import safe_read_csv, upload_dataframe_to_table

SOURCES_PATH = "sources.yml"

if __name__ == "__main__":
    # Load the sources file
    with open(Path(os.path.dirname(__file__)) / SOURCES_PATH, "r") as ymlfile:
        sources = yaml.safe_load(ymlfile)

    code_postaux = safe_read_csv(sources["codes_postaux"]["url"])
    upload_dataframe_to_table(code_postaux, "code_postaux")

    codes_geographiques_communes = safe_read_csv(sources["codes_geographiques_communes"]["url"])
    upload_dataframe_to_table(codes_geographiques_communes, "codes_geographiques_communes")

    codes_geographiques_arrondissements = safe_read_csv(sources["codes_geographiques_arrondissements"]["url"])
    upload_dataframe_to_table(codes_geographiques_arrondissements, "codes_geographiques_arrondissements")

    codes_geographiques_departements = safe_read_csv(sources["codes_geographiques_departements"]["url"])
    upload_dataframe_to_table(codes_geographiques_departements, "codes_geographiques_departements")

    codes_geographiques_regions = safe_read_csv(sources["codes_geographiques_regions"]["url"])
    upload_dataframe_to_table(codes_geographiques_regions, "codes_geographiques_regions")
