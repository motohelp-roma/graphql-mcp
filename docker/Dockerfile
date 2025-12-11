# =============================================================================
# Apollo MCP Server per Motohelp GraphQL API
# =============================================================================
FROM ghcr.io/apollographql/apollo-mcp-server:latest AS mcp-server

# Usiamo una immagine base leggera con le utilities necessarie
FROM debian:bookworm-slim

# Installa curl per scaricare lo schema e ca-certificates per HTTPS
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Copia il binario Apollo MCP Server dall'immagine ufficiale
COPY --from=mcp-server /usr/local/bin/apollo-mcp-server /usr/local/bin/apollo-mcp-server

# Crea directory per configurazione e dati
RUN mkdir -p /app /data

WORKDIR /app

# Copia lo script di entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Copia la configurazione template
COPY config.yaml /app/config.yaml

# Variabili d'ambiente configurabili
ENV GRAPHQL_ENDPOINT="https://api.dev.officinemoto.com/graphql"
ENV MCP_PORT="8000"
ENV MCP_HOST="0.0.0.0"
ENV INTROSPECTION_ENABLED="true"
ENV EXECUTE_ENABLED="true"
# Headers opzionali (JSON format)
ENV GRAPHQL_HEADERS="{}"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${MCP_PORT}/health || exit 1

# Esponi la porta MCP
EXPOSE 8000

# Entrypoint che scarica lo schema e avvia il server
ENTRYPOINT ["/app/entrypoint.sh"]
