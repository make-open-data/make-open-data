FROM pgduckdb/pgduckdb:16-v0.1.0

USER root

RUN apt-get update && apt-get install -y \
  postgresql-16-postgis-3 \
  postgresql-16-postgis-3-scripts \
  && rm -rf /var/lib/apt/lists/*

COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh

USER postgres
