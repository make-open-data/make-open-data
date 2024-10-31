import dataclasses
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


@dataclasses.dataclass
class Scenario:
    csv_filename: str
    delimiter: str
    expected_row_count: int
    expected_first_row_data: dict[str, Any]


SCENARIOS = [
    Scenario(
        csv_filename="base-officielle-codes-postaux",
        delimiter=",",
        expected_row_count=9,
        expected_first_row_data={
            "code_commune_insee": "69381",
            "nom_de_la_commune": "LYON 01",
            "code_postal": "69001",
            "libelle_d_acheminement": "LYON",
            "ligne_5": None,
            "_geopoint": "45.770104,4.826373",
        }
    ),
]


@pytest.mark.parametrize(
    argnames=["scenario"],
    ids=[scenario.csv_filename for scenario in SCENARIOS],
    argvalues=[[scenario] for scenario in SCENARIOS],
)
def test_load_file_to_pg(
    db_connection: psycopg.Connection,
    scenario: Scenario,
):
    """
    Étant donné un fichier csv,
    Quand la fonction load_file_to_pg est appelée avec ce fichier,
    Alors les données sont correctéments chargées en BDD.
    """

    # Étant donné un fichier csv,
    # Quand la fonction load_file_to_pg est appelée avec ce fichier,
    load_file_to_pg(
        tmpfile_csv_path=f"tests/resources/{scenario.csv_filename}.csv",
        pg_table="test_load_file_to_pg",
        data_infos={
            "db_schema": "test_sources",
            "csv_delimiter": scenario.delimiter,
            "file_format": "csv",
        },
    )
    with (db_connection.cursor(row_factory=rows.dict_row) as cursor):
        result: Cursor = cursor.execute("SELECT * from test_sources.test_load_file_to_pg")

        assert result.rowcount == scenario.expected_row_count
        actual_first_row_data: list[dict[str, Any]] = result.fetchone()

        assert actual_first_row_data == scenario.expected_first_row_data
