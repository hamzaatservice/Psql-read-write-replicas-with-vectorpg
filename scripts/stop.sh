#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

if [[ "${1:-}" == "--volumes" ]]; then
  compose down -v
  echo "Stack stopped and volumes removed."
else
  compose down
  echo "Stack stopped."
fi

