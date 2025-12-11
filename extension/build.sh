#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

OUTPUT_FILE="motohelp-graphql.mcpb"

echo "Building Motohelp MCP Extension..."
rm -f "$OUTPUT_FILE"

REQUIRED_FILES=("manifest.json" "server/index.js" "icon.png")
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Missing required file: $file"
        exit 1
    fi
done

zip -r "$OUTPUT_FILE" manifest.json server/ icon.png package.json -x "*.DS_Store"

echo "Build complete: ${OUTPUT_FILE}"
unzip -l "$OUTPUT_FILE"
