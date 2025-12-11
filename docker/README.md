# Motohelp - Apollo MCP Server

Deploy di Apollo MCP Server per esporre le API GraphQL di Motohelp come tools MCP.

## Quick Start

```bash
docker compose build
docker compose up -d
curl http://localhost:8000/health
```

## Configurazione

| Variabile | Default | Descrizione |
|-----------|---------|-------------|
| GRAPHQL_ENDPOINT | https://api.dev.officinemoto.com/graphql | URL endpoint GraphQL |
| MCP_PORT | 8000 | Porta server MCP |
| INTROSPECTION_ENABLED | true | Abilita tool introspect |
| EXECUTE_ENABLED | true | Abilita tool execute |
| REFRESH_SCHEMA | true | Scarica schema ad ogni avvio |
| GRAPHQL_HEADERS | {} | Headers aggiuntivi (JSON) |

## Deploy

### Fly.io

```bash
fly auth login
fly launch --name motohelp-mcp --no-deploy
fly deploy
```

### Docker generico

```bash
docker build -t motohelp-mcp .
docker run -d -p 8000:8000 --name motohelp-mcp motohelp-mcp
```
