#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

echo "=== Container status ==="
compose ps

echo
echo "=== Primary replication status ==="
compose exec -T pg-primary psql -U postgres -d postgres -c \
"SELECT application_name, state, sync_state, client_addr, write_lag, flush_lag, replay_lag
 FROM pg_stat_replication
 ORDER BY application_name;"

echo
echo "=== Replica1 recovery status ==="
compose exec -T pg-replica1 psql -U postgres -d postgres -c \
"SELECT pg_is_in_recovery() AS is_replica, COALESCE(NOW() - pg_last_xact_replay_timestamp(), INTERVAL '0') AS replay_delay;"

echo
echo "=== Replica2 recovery status ==="
compose exec -T pg-replica2 psql -U postgres -d postgres -c \
"SELECT pg_is_in_recovery() AS is_replica, COALESCE(NOW() - pg_last_xact_replay_timestamp(), INTERVAL '0') AS replay_delay;"

echo
echo "=== pgvector extension status ==="
compose exec -T pg-vector psql -U "${VECTOR_DB_USER}" -d "${VECTOR_DB_NAME}" -c \
"SELECT extname, extversion FROM pg_extension WHERE extname='vector';"

