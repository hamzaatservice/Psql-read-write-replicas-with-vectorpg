#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose
ensure_backup_dir

ts="$(date +%Y%m%d_%H%M%S)"
app_file="${BACKUP_DIR}/app_db_${ts}.dump"
vector_file="${BACKUP_DIR}/vector_db_${ts}.dump"

compose exec -T pg-primary sh -lc \
"PGPASSWORD='${APP_DB_PASSWORD}' pg_dump -U '${APP_DB_USER}' -d '${APP_DB_NAME}' -Fc --no-owner --no-privileges" \
> "${app_file}"

compose exec -T pg-vector sh -lc \
"PGPASSWORD='${VECTOR_DB_PASSWORD}' pg_dump -U '${VECTOR_DB_USER}' -d '${VECTOR_DB_NAME}' -Fc --no-owner --no-privileges" \
> "${vector_file}"

echo "Backup completed:"
echo "${app_file}"
echo "${vector_file}"

