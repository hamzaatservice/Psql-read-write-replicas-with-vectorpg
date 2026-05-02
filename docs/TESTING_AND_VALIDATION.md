# Testing and validation
## Objective
Validate that:
1. Primary accepts writes.
2. Replicas serve read traffic and receive replicated data.
3. pgvector extension and similarity queries work.
4. Backup script generates valid artifacts.

## Validation scripts
- `scripts/test_replication.sh`
  - inserts test row into primary
  - verifies row on both replicas
- `scripts/test_vector.sh`
  - checks extension
  - inserts sample document and embedding
  - executes similarity query
- `tests/run_all.sh`
  - runs init, status, replication test, vector test, backup

## Execution steps
1. `chmod +x scripts/*.sh tests/*.sh`
2. `./scripts/manage.sh init`
3. `./scripts/manage.sh status`
4. `./scripts/manage.sh test-replication`
5. `./scripts/manage.sh test-vector`
6. `./scripts/manage.sh backup`
7. `./tests/run_all.sh`

## Success criteria
- `status.sh` shows replicas in recovery mode.
- test row written to primary is visible from both replicas.
- vector test returns a similarity match.
- dump files exist in `backups/`.

