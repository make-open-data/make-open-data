"""
This module host loaders to safely download sources files and upload csv to database
"""

import yaml
import requests
from io import StringIO
import certifi

import pandas as pd
from sqlalchemy import create_engine



# Load the profiles.yml file
with open('./profiles.yml', 'r') as file:
    profiles = yaml.safe_load(file)

# Get the login information
profile = profiles['makeopendata']['outputs']['dev']
host = profile['host']
database = profile['dbname']
user = profile['user']
password = profile['pass']

# Create a connection to the database
engine = create_engine(f'postgresql://{user}:{password}@{host}/{database}')



def safe_read_csv(path, rows_to_skip=None):
    """
    Wrapper around pandas.read_csv to safely download the file from the given path without raisin ssl errors
    """
    # Download the CSV file
    response = requests.get(path, verify=certifi.where())

    # Make sure the download was successful
    response.raise_for_status()

    # Load the data from the downloaded file
    data = pd.read_csv(StringIO(response.text), skiprows=rows_to_skip)

    return data


def upload_dataframe_to_table(data, table_name):
    """
    Upload a dataframe to a table in the database
    """
    data.to_sql(table_name, engine, if_exists='replace', index=False)