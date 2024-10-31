import importlib
from typing import Any

import psycopg
import pytest
from psycopg import rows, Cursor

from load import loaders
from load.loaders import load_file_to_pg


@pytest.fixture(scope="module", autouse=True)
def setup_module():
    """
    Le module loaders affecte des variables globales à partir des variables
    d'environnement, au chargement du module.
    Recharger le module, après l'exécution de notre fixture qui définit les variables
    d'environnement pour la connexion à la BDD de test.
    """
    importlib.reload(loaders)


def test_load_file_to_pg(
    db_connection: psycopg.Connection,
):
    """
    Étant donné un fichier csv,
    Quand la fonction load_file_to_pg est appelée avec ce fichier,
    Alors les données sont correctéments chargées en BDD.
    """

    # Étant donné un fichier csv,
    # Quand la fonction load_file_to_pg est appelée avec ce fichier,
    load_file_to_pg(
        tmpfile_csv_path="tests/resources/base-officielle-codes-postaux.csv",
        pg_table="test_load_file_to_pg",
        data_infos={
            "db_schema": "test_sources",
            "csv_delimiter": ","
            "file_format": "csv",
        },
    )
    with (db_connection.cursor(row_factory=rows.dict_row) as cursor):
        result: Cursor = cursor.execute("SELECT * from test_sources.test_load_file_to_pg")

        assert result.rowcount == 9
        actual_first_row_data: list[dict[str, Any]] = result.fetchone()
        expected_first_row_data = {
            "code_commune_insee": "69381",
            "nom_de_la_commune": "LYON 01",
            "code_postal": "69001",
            "libelle_d_acheminement": "LYON",
            "ligne_5": None,
            "_geopoint": "45.770104,4.826373",
        }

        assert actual_first_row_data == expected_first_row_data
