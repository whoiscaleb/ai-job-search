#!/usr/bin/env bash
# Rebuilds CommunityLab from scratch (all bugs back in place) using the Docker SQL Server container.
# Usage: ./scripts/reset-db.sh            (container name defaults to "sqllab")
set -euo pipefail
CONTAINER="${SQL_CONTAINER:-sqllab}"
PASSWORD="${SA_PASSWORD:-Lab_Passw0rd!}"
DIR="$(cd "$(dirname "$0")/../database" && pwd)"
for f in 00_create_database.sql 01_schema.sql 02_seed_data.sql 03_procedures.sql; do
  echo "Running $f"
  docker exec -i "$CONTAINER" /opt/mssql-tools18/bin/sqlcmd -C -b -S localhost -U sa -P "$PASSWORD" < "$DIR/$f"
done
echo "CommunityLab is ready."
