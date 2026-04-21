#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/common.sh"

log "Configuring XMLUI MCP server for Claude"

require_cmd claude

detect_platform
if [[ "${PLATFORM_OS}" == "win" ]]; then
  CLI_BINARY_NAME="xmlui.exe"
else
  CLI_BINARY_NAME="xmlui"
fi

if ! command -v "${CLI_BINARY_NAME}" >/dev/null 2>&1; then
  fail "XMLUI CLI not on PATH. Run install-cli first."
fi

if claude mcp list 2>/dev/null | grep -q "xmlui"; then
  log "MCP server 'xmlui' already configured"
  exit 0
fi

if claude mcp add xmlui -- xmlui mcp >/dev/null 2>&1; then
  log "MCP server 'xmlui' configured with 'xmlui mcp'"
elif [[ "${PLATFORM_OS}" == "win" ]] && claude mcp add xmlui -- xmlui.exe mcp >/dev/null 2>&1; then
  log "MCP server 'xmlui' configured with 'xmlui.exe mcp'"
else
  fail "Failed to configure MCP with 'claude mcp add'."
fi

if claude mcp list 2>/dev/null | grep -q "xmlui"; then
  log "Verified MCP server 'xmlui'"
else
  fail "MCP server 'xmlui' not found after add attempt"
fi
