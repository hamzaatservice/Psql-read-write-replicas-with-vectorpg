# Manual alterations before production
## Required configuration changes
1. Create `.env` from `.env.example`.
2. Replace all default passwords with secure values.
3. Adjust ports if they conflict with your environment.
4. Configure backup destination to remote object storage.
5. Configure TLS for API and database connectivity.

## Application-level required changes
1. Backend must use distinct pools:
   - primary pool for writes
   - replica pool for reads
   - vector pool for pgvector queries
2. Add read-after-write policy:
   - critical reads go to primary
   - non-critical reads go to replicas

## Security hardening changes
1. Add read-only role for replicas.
2. Restrict DB network access to backend/worker only.
3. Rotate database and replication credentials on schedule.

## Operational manual checks
1. Confirm replication lag thresholds and alerts.
2. Run periodic failover drill using replica promotion.
3. Run monthly restore drill from generated backups.

