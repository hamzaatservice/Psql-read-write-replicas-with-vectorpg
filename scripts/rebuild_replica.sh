#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

target="${1:-}"
case "${target}" in
  replica1) service="pg-replica1"; vol="${COMPOSE_PROJECT_NAME}_pg_replica1_data" ;;
  replica2) service="pg-replica2"; vol="${COMPOSE_PROJECT_NAME}_pg_replica2_data" ;;
  *) echo "Usage: ./scripts/rebuild_replica.sh replica1|replica2"; exit 1 ;;
esac

compose stop "${service}"
compose rm -f "${service}"
docker volume rm "${vol}" >/dev/null 2>&1 || true
compose up -d "${service}"
wait_for_pg "${service}" postgres postgres

echo "${service} rebuilt."

