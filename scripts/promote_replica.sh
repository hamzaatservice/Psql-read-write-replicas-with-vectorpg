#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

target="${1:-}"
case "${target}" in
  replica1) service="pg-replica1" ;;
  replica2) service="pg-replica2" ;;
  *) echo "Usage: ./scripts/promote_replica.sh replica1|replica2"; exit 1 ;;
esac

compose exec -T "${service}" psql -U postgres -d postgres -c "SELECT pg_promote(wait_seconds => 60);"
echo "Promotion requested for ${service}. Update application write endpoint to new primary."

