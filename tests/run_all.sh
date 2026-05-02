#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${ROOT_DIR}/scripts/init.sh"
"${ROOT_DIR}/scripts/status.sh"
"${ROOT_DIR}/scripts/test_replication.sh"
"${ROOT_DIR}/scripts/test_vector.sh"
"${ROOT_DIR}/scripts/backup.sh"

echo "All validations completed successfully."
