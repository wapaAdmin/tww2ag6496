import os
import subprocess
import sys
from argparse import ArgumentParser, BooleanOptionalAction
from pathlib import Path
from typing import Optional

from yaml import safe_load

try:
    import psycopg
except ImportError:
    import psycopg2 as psycopg


def read_config(config_file: str, extension_name: str):
    with open(config_file) as file:
        config = safe_load(file)
    for entry in config.get("extensions", []):
        if entry.get("id") == extension_name:
            return entry
    raise ValueError(f"No entry found with id: {extension_name}")


def run_py_file(file_path: str):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    result = subprocess.run([sys.executable, str(abs_file_path)], capture_output=True, text=True)

    if result.returncode != 0:
        raise RuntimeError(f"Error running file: {result.stderr}")


def run_sql_file(file_path: str, pg_service: str, variables: dict = None):
    abs_file_path = Path(__file__).parent.resolve() / file_path
    with open(abs_file_path) as f:
        sql = f.read()
    run_sql(sql, pg_service, variables)


def run_sql(sql: str, pg_service: str, variables: dict = None):
    if variables:
        sql = psycopg.sql.SQL(sql).format(**variables)
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute(sql)
    conn.commit()
    conn.close()


def load_extension(
    srid: int = 2056,
    pg_service: str = "pg_tww",
    extension_name: str = None,
    drop_schema: Optional[bool] = False,
):
    """
    initializes the TWW database for usage of an extension

    Args:
        pgservice: pg service string
        extension_name: Name of the extension to load

    """

    # load definitions from config
    config = read_config("config.yaml", extension_name)
    variables = config.get("variables", {})
    # pass SRID and extension schema name per default
    schemaname = config.get("schema", "tww_" + extension_name)
    variables.update({"ext_schema": schemaname, "srid": psycopg.sql.SQL(f"{srid}")})

    if drop_schema:
        run_sql(f"DROP SCHEMA IF EXISTS {schemaname} CASCADE;", pg_service)

    # We also disable symbology triggers as they can badly affect performance. This must be done in a separate session as it
    # would deadlock other sessions.
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute("SELECT tww_sys.disable_symbology_triggers();")
    conn.commit()
    conn.close()

    directory = config.get("directory", None)
    if directory:
        files = os.listdir(os.path.join(directory, os.pardir))
        files.sort()
        for file in files:
            filename = os.fsdecode(file)
            if filename.endswith(".sql"):
                run_sql_file(os.path.join(directory, filename), pg_service, variables)
            if filename.endswith(".py"):
                run_py_file(os.path.join(directory, filename))

    # re-create symbology triggers
    conn = psycopg.connect(f"service={pg_service}")
    cursor = conn.cursor()
    cursor.execute("SELECT tww_sys.enable_symbology_triggers();")
    conn.commit()
    conn.close()


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("-p", "--pg_service", help="postgres service")
    parser.add_argument(
        "-s", "--srid", help="SRID EPSG code, defaults to 2056", type=int, default=2056
    )
    parser.add_argument(
        "-x --extension_name",
        help="name of the database extension",
    )
    parser.add_argument(
        "-d",
        "--drop-schema",
        help="Drops cascaded any existing extension schema",
        default=False,
        action=BooleanOptionalAction,
    )
    args = parser.parse_args()

    load_extension(
        args.srid,
        args.pg_service,
        args.extension_name,
        drop_schema=args.drop_schema,
    )
