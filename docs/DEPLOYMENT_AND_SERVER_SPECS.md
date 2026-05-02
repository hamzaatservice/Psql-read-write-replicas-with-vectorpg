# Deployment and server specs
## Recommended server count
Minimum production target:
1. Frontend servers: 2
2. Backend API servers: 2
3. PostgreSQL primary: 1
4. PostgreSQL read replicas: 2
5. pgvector database: 1
6. AI worker servers: 1 to 2

Total: 8 to 9+ servers depending HA level.

## Suggested baseline specs
- Frontend node: 2 vCPU, 4 GB RAM, 40 GB SSD
- Backend node: 4 vCPU, 8-16 GB RAM, 60 GB SSD
- Postgres primary: 8 vCPU, 32 GB RAM, 300+ GB NVMe
- Postgres replica (each): 8 vCPU, 32 GB RAM, 300+ GB NVMe
- pgvector node: 8-16 vCPU, 32-64 GB RAM, 500+ GB NVMe
- Worker node: 4-8 vCPU, 16 GB RAM

## Why these specs
- Replication and vector indexing are memory and IOPS intensive.
- Backend API requires CPU/memory for concurrency, pooling, and AI orchestration.
- Fast storage minimizes commit and query latency.

## Deployment order
1. Deploy network boundaries and private DB subnet.
2. Deploy transactional DB primary.
3. Deploy and validate read replicas.
4. Deploy pgvector DB.
5. Deploy backend with read/write/vector routing.
6. Deploy frontend and workers.
7. Run full validation scripts before production traffic.

