#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<EOF
Usage: ./scripts/manage.sh <command>

Commands:
  init
  start
  stop [--volumes]
  status
  test-replication
  test-vector
  backup
  restore --app <file> [--vector <file>]
  promote replica1|replica2
  rebuild replica1|replica2
EOF
}

cmd="${1:-}"
shift || true

case "${cmd}" in
  init) "${SCRIPT_DIR}/init.sh" "$@" ;;
  start) "${SCRIPT_DIR}/start.sh" "$@" ;;
  stop) "${SCRIPT_DIR}/stop.sh" "$@" ;;
  status) "${SCRIPT_DIR}/status.sh" "$@" ;;
  test-replication) "${SCRIPT_DIR}/test_replication.sh" "$@" ;;
  test-vector) "${SCRIPT_DIR}/test_vector.sh" "$@" ;;
  backup) "${SCRIPT_DIR}/backup.sh" "$@" ;;
  restore) "${SCRIPT_DIR}/restore.sh" "$@" ;;
  promote) "${SCRIPT_DIR}/promote_replica.sh" "$@" ;;
  rebuild) "${SCRIPT_DIR}/rebuild_replica.sh" "$@" ;;
  -h|--help|"") usage ;;
  *) echo "Unknown command: ${cmd}"; usage; exit 1 ;;
esac
