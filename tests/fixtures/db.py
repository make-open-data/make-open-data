"""
Fournit des fixtures pytest nécessaires pour la connexion à la BDD de test.
"""
import os

import psycopg
import pytest


@pytest.fixture(scope="session", autouse=True)
def setup_postgres_env_vars():
    """
    Définir nos variables d'environnement pour la connexion à la BDD de test.
    """
    os.environ['POSTGRES_USER'] = 'postgres'
    os.environ['POSTGRES_PASSWORD'] = 'mysecretpassword'
    os.environ['POSTGRES_HOST'] = 'localhost'
    os.environ['POSTGRES_PORT'] = '9432'
    os.environ['POSTGRES_DB'] = 'postgres'


def _get_db_connection() -> psycopg.Connection:
    return psycopg.connect(
        host=os.getenv("POSTGRES_HOST"),
        port=os.getenv("POSTGRES_PORT"),
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
    )


@pytest.fixture()
def db_connection(postgres_service) -> psycopg.Connection:
    """
    :return: une connexion à la BDD de test
    """
    connection = _get_db_connection()
    yield connection
    connection.close()


def _is_db_up() -> bool:
    """
    :return: True si la BDD de test est joignable.
    """
    connection = None
    try:
        connection = _get_db_connection()
    except Exception as e:
        return False
    finally:
        if connection:
            connection.close()
    return True


@pytest.fixture(scope="session")
def postgres_service(
    docker_services,
):
    """
    Démarrer notre BDD de test, et bloquer jusqu'à ce que la BDD est joignable.
    """
    docker_services.wait_until_responsive(
        timeout=30.0,
        pause=0.1,
        check=_is_db_up,
    )
