#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

compose up -d pg-primary pg-replica1 pg-replica2 pg-vector
wait_for_pg pg-primary postgres postgres
wait_for_pg pg-replica1 postgres postgres
wait_for_pg pg-replica2 postgres postgres
wait_for_pg pg-vector "${VECTOR_DB_USER}" "${VECTOR_DB_NAME}"

echo "Stack initialized successfully."

