#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_FILE="${ROOT_DIR}/docker-compose.yml"
ENV_FILE="${ROOT_DIR}/.env"
ENV_EXAMPLE_FILE="${ROOT_DIR}/.env.example"
BACKUP_DIR="${ROOT_DIR}/backups"

load_env() {
  if [[ ! -f "${ENV_FILE}" ]]; then
    cp "${ENV_EXAMPLE_FILE}" "${ENV_FILE}"
    echo "Created ${ENV_FILE} from .env.example. Update passwords before production use."
  fi
  set -a
  # shellcheck disable=SC1090
  source "${ENV_FILE}"
  set +a
}

require_docker_compose() {
  command -v docker >/dev/null 2>&1 || { echo "docker is required."; exit 1; }
  docker compose version >/dev/null 2>&1 || { echo "docker compose is required."; exit 1; }
}

compose() {
  docker compose --env-file "${ENV_FILE}" -f "${COMPOSE_FILE}" "$@"
}

wait_for_pg() {
  local service="$1"
  local user="$2"
  local db="$3"
  local attempts="${4:-40}"
  for ((i=1; i<=attempts; i++)); do
    if compose exec -T "${service}" pg_isready -U "${user}" -d "${db}" >/dev/null 2>&1; then
      echo "${service} is ready."
      return 0
    fi
    sleep 2
  done
  echo "Timed out waiting for ${service}." >&2
  return 1
}

ensure_backup_dir() {
  mkdir -p "${BACKUP_DIR}"
}

