#!/bin/bash
set -e

echo "Motohelp - Apollo MCP Server"
echo "GraphQL Endpoint: ${GRAPHQL_ENDPOINT}"
echo "MCP Port: ${MCP_PORT}"

download_schema() {
    echo "Downloading GraphQL schema via introspection..."
    INTROSPECTION_QUERY='{"query":"{ __schema { types { name kind } } }"}'
    
    CURL_HEADERS=""
    if [ "${GRAPHQL_HEADERS}" != "{}" ] && [ -n "${GRAPHQL_HEADERS}" ]; then
        CURL_HEADERS=$(echo "${GRAPHQL_HEADERS}" | jq -r 'to_entries | .[] | "-H " + .key + ": " + .value' | tr '\n' ' ')
    fi
    
    RESPONSE=$(curl -s -X POST "${GRAPHQL_ENDPOINT}" -H "Content-Type: application/json" -d "${INTROSPECTION_QUERY}" 2>&1)
    
    if echo "${RESPONSE}" | jq -e '.data.__schema' > /dev/null 2>&1; then
        echo "${RESPONSE}" > /data/introspection-result.json
        echo "Schema introspection saved"
        echo "type Query { _placeholder: String }" > /data/schema.graphql
    else
        echo "Failed to download schema"
        if [ ! -f "/data/schema.graphql" ]; then
            echo "type Query { _placeholder: String }" > /data/schema.graphql
        fi
    fi
}

generate_config() {
    cat > /data/config.yaml << EOF
endpoint: ${GRAPHQL_ENDPOINT}
transport:
  type: streamable_http
  port: ${MCP_PORT}
  host: ${MCP_HOST}
schema:
  source: local
  path: /data/schema.graphql
introspection:
  introspect:
    enabled: ${INTROSPECTION_ENABLED}
  execute:
    enabled: ${EXECUTE_ENABLED}
EOF
    echo "Configuration saved"
}

main() {
    if [ ! -f "/data/schema.graphql" ] || [ "${REFRESH_SCHEMA}" = "true" ]; then
        download_schema
    fi
    generate_config
    echo "Starting Apollo MCP Server..."
    exec /usr/local/bin/apollo-mcp-server /data/config.yaml
}

main "$@"
