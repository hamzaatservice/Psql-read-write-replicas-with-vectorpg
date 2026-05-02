#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

usage() {
  cat <<EOF
Usage:
  ./scripts/restore.sh --app backups/app_db_xxx.dump --vector backups/vector_db_xxx.dump
  ./scripts/restore.sh --app backups/app_db_xxx.dump
  ./scripts/restore.sh --vector backups/vector_db_xxx.dump
EOF
}

load_env
require_docker_compose

app_dump=""
vector_dump=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --app) app_dump="${2:-}"; shift 2 ;;
    --vector) vector_dump="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

if [[ -z "${app_dump}" && -z "${vector_dump}" ]]; then
  usage
  exit 1
fi

if [[ -n "${app_dump}" ]]; then
  [[ -f "${app_dump}" ]] || { echo "Missing ${app_dump}"; exit 1; }
  cat "${app_dump}" | compose exec -T pg-primary sh -lc \
"PGPASSWORD='${APP_DB_PASSWORD}' pg_restore -U '${APP_DB_USER}' -d '${APP_DB_NAME}' --clean --if-exists --no-owner --no-privileges"
fi

if [[ -n "${vector_dump}" ]]; then
  [[ -f "${vector_dump}" ]] || { echo "Missing ${vector_dump}"; exit 1; }
  cat "${vector_dump}" | compose exec -T pg-vector sh -lc \
"PGPASSWORD='${VECTOR_DB_PASSWORD}' pg_restore -U '${VECTOR_DB_USER}' -d '${VECTOR_DB_NAME}' --clean --if-exists --no-owner --no-privileges"
fi

echo "Restore completed."

