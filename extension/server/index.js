#!/usr/bin/env node
const { spawn } = require('child_process');

const MCP_ENDPOINT = process.env.MCP_ENDPOINT || 'https://api.dev.officinemoto.com/mcp';
const npxPath = process.platform === 'win32' ? 'npx.cmd' : 'npx';

console.error(`[motohelp-mcp] Connecting to ${MCP_ENDPOINT}...`);

const mcpRemote = spawn(npxPath, ['-y', 'mcp-remote', MCP_ENDPOINT], {
  stdio: ['pipe', 'pipe', 'inherit'],
  env: { ...process.env, NO_COLOR: '1', FORCE_COLOR: '0' }
});

process.stdin.pipe(mcpRemote.stdin);
mcpRemote.stdout.pipe(process.stdout);

mcpRemote.on('error', (err) => {
  console.error(`[motohelp-mcp] Error: ${err.message}`);
  process.exit(1);
});

mcpRemote.on('close', (code) => {
  console.error(`[motohelp-mcp] Connection closed with code ${code}`);
  process.exit(code || 0);
});

process.on('SIGINT', () => mcpRemote.kill('SIGINT'));
process.on('SIGTERM', () => mcpRemote.kill('SIGTERM'));
process.stdin.on('end', () => mcpRemote.stdin.end());
