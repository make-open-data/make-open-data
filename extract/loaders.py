"""
This module host loaders to safely download sources files and upload csv to database
"""
import gzip
import os
import requests
from io import StringIO
import certifi

import pandas as pd
from sqlalchemy import create_engine



user = os.getenv('POSTGRES_USER')
password = os.getenv('POSTGRES_PASSWORD')
host = os.getenv('POSTGRES_HOST')
port = os.getenv('POSTGRES_PORT')
database = os.getenv('POSTGRES_DB')

# Create a connection to the database
ENGINE = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{database}')

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
}

def safe_read_csv(path, rows_to_skip=None):
    """
    Wrapper around pandas.read_csv to safely download the file from the given path without raisin ssl errors
    """
    # Download the CSV file
    response = requests.get(path, headers=HEADERS, verify=certifi.where())

    # Check if the file is gzipped
    if path.endswith('.gz'):
        # Decompress the gzipped data
        decompressed_file = gzip.decompress(response.content)
        # Load the data from the decompressed file
        data = pd.read_csv(StringIO(decompressed_file.decode('utf-8')), low_memory=False, skiprows=rows_to_skip)
    else:
        # Load the data from the downloaded file
        data = pd.read_csv(StringIO(response.text), skiprows=rows_to_skip)

    return data


def upload_dataframe_to_table(data, table_name):
    """
    Upload a dataframe to a table in the database
    """
    data.to_sql(table_name, ENGINE, if_exists='replace', index=False)