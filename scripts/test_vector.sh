#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

load_env
require_docker_compose

echo "Checking vector extension..."
compose exec -T pg-vector psql -U "${VECTOR_DB_USER}" -d "${VECTOR_DB_NAME}" -c \
"SELECT extname FROM pg_extension WHERE extname='vector';"

echo "Inserting sample vector row..."
compose exec -T pg-vector psql -U "${VECTOR_DB_USER}" -d "${VECTOR_DB_NAME}" -c \
"INSERT INTO documents(external_id, content, metadata)
 VALUES('doc-1', 'sample content', '{\"source\":\"test\"}')
 ON CONFLICT (external_id) DO NOTHING;"

compose exec -T pg-vector psql -U "${VECTOR_DB_USER}" -d "${VECTOR_DB_NAME}" -c \
"INSERT INTO document_embeddings(document_id, embedding, model)
 SELECT id, array_fill(0.01::real, ARRAY[1536])::vector, 'test-model'
 FROM documents WHERE external_id='doc-1'
 ON CONFLICT DO NOTHING;"

echo "Running similarity query..."
compose exec -T pg-vector psql -U "${VECTOR_DB_USER}" -d "${VECTOR_DB_NAME}" -c \
"SELECT de.id, d.external_id, de.model
 FROM document_embeddings de
 JOIN documents d ON d.id = de.document_id
 ORDER BY de.embedding <=> array_fill(0.01::real, ARRAY[1536])::vector
 LIMIT 1;"

echo "Vector test completed."

