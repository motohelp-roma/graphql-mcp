# 🏍️ Motohelp GraphQL MCP

Questo repository contiene tutto il necessario per esporre le API GraphQL di Motohelp come tools MCP (Model Context Protocol) per Claude e altri client AI.

## 📋 Contenuto

| Directory | Descrizione |
|-----------|-------------|
| [`docker/`](./docker/) | Server Apollo MCP da deployare |
| [`extension/`](./extension/) | Claude Desktop Extension (`.mcpb`) |

## 🚀 Quick Start

### 1. Deploy del server MCP

```bash
cd docker
docker compose up -d
```

Il server sarà disponibile su `http://localhost:8000/mcp`

### 2. Installazione Extension (per il team)

1. Scarica [`extension/motohelp-graphql.mcpb`](./extension/motohelp-graphql.mcpb)
2. Doppio click sul file
3. Claude Desktop si apre → clicca "Install"
4. Chiedi a Claude: *"Quali API GraphQL hai disponibili per Motohelp?"*

## 🔧 Architettura

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Claude Desktop │────▶│  Apollo MCP      │────▶│  GraphQL API    │
│  (Extension)    │     │  Server          │     │  (staging/prod) │
└─────────────────┘     └──────────────────┘     └─────────────────┘
        │                       │
        │ stdio                 │ HTTP
        ▼                       ▼
   mcp-remote ────────▶ api.dev.officinemoto.com/mcp
```

## 📚 Documentazione

- **Server MCP**: Vedi [docker/README.md](./docker/README.md)
- **Extension**: Vedi [extension/README.md](./extension/README.md)
- [Apollo MCP Server Docs](https://www.apollographql.com/docs/apollo-mcp-server)
- [Claude Desktop Extensions](https://www.anthropic.com/engineering/desktop-extensions)
- [Model Context Protocol](https://modelcontextprotocol.io/)

## 🔒 Ambienti

| Ambiente | GraphQL Endpoint | MCP Endpoint |
|----------|------------------|--------------|
| Staging | `https://api.dev.officinemoto.com/graphql` | `https://api.dev.officinemoto.com/mcp` |
| Production | `https://api.officinemoto.com/graphql` | `https://api.officinemoto.com/mcp` |

## 📄 Licenza

MIT License - Motohelp
