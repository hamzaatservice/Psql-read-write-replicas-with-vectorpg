#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

echo "Inserting test row on primary..."
compose exec -T pg-primary psql -U "${APP_DB_USER}" -d "${APP_DB_NAME}" -c \
"INSERT INTO users(email, full_name) VALUES('replica-test@example.com', 'Replica Test User')
 ON CONFLICT (email) DO NOTHING;"

echo "Checking row visibility on replica1..."
compose exec -T pg-replica1 psql -U "${APP_DB_USER}" -d "${APP_DB_NAME}" -c \
"SELECT id, email, full_name, created_at FROM users WHERE email='replica-test@example.com';"

echo "Checking row visibility on replica2..."
compose exec -T pg-replica2 psql -U "${APP_DB_USER}" -d "${APP_DB_NAME}" -c \
"SELECT id, email, full_name, created_at FROM users WHERE email='replica-test@example.com';"

echo "Replication test completed."

