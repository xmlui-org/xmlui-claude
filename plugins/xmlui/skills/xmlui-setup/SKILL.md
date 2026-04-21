---
name: xmlui-setup
description: Set up a complete XMLUI development environment. Use when the user wants to start XMLUI development, install the XMLUI CLI, configure the MCP server, or create a new XMLUI project.
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, AskUserQuestion
---

# XMLUI Development Environment Setup

`xmlui-setup` downloads the `xmlui-weather` app (which includes the Inspector for debugging) and starts a local webserver to run the app.

Detect the OS first, then run the appropriate commands for the platform:

- **Windows**: use `.cmd` wrappers — they invoke the matching `.ps1` via `powershell.exe -ExecutionPolicy Bypass` so execution policy is never a blocker.
- **macOS / Linux**: use `.sh` scripts.

Run every step automatically — do not ask the user for confirmation between steps.

---

## Step 1: Preflight

- **macOS/Linux:** `"${CLAUDE_SKILL_DIR}/scripts/preflight.sh"`
- **Windows:** `"${CLAUDE_SKILL_DIR}/scripts/preflight.cmd"`

If it fails, tell the user what to install and stop. Common issues:

- `curl` missing: install via system package manager
- `claude`/`claude.cmd` missing: Claude Code CLI is not installed or not on PATH
- `tar` missing (macOS/Linux): install via system package manager
- `Expand-Archive` missing (Windows): requires PowerShell 5.1+ or PowerShell 7+

Do not proceed until preflight passes.

---

## Step 2: Ensure the CLI is available

**macOS/Linux:** The MCP server's `.mcp.json` auto-downloads the CLI on first use. Verify it's ready:

```bash
"${CLAUDE_PLUGIN_DATA}/bin/xmlui" --help
```

If this fails, install manually:

```bash
CLAUDE_PLUGIN_DATA="${CLAUDE_PLUGIN_DATA}" "${CLAUDE_SKILL_DIR}/scripts/install-cli.sh"
```

**Windows:** The `.mcp.json` auto-installer uses bash and does not support Windows natively. Install via the PowerShell wrapper:

```bash
"${CLAUDE_SKILL_DIR}/scripts/install-cli.cmd"
```

This installs `xmlui.exe` to `%CLAUDE_PLUGIN_DATA%\bin\` if `CLAUDE_PLUGIN_DATA` is set, otherwise to `%USERPROFILE%\bin\`, and adds it to the user PATH permanently (takes effect in new terminals).

---

## Step 3: MCP server

**macOS/Linux:** The MCP server is configured automatically via the plugin's `.mcp.json`. No manual setup or extra restart needed.

**Windows:** The `.mcp.json` wrapper uses bash and does not support Windows natively. Configure the MCP server manually:

```bash
"${CLAUDE_SKILL_DIR}/scripts/configure-mcp.cmd"
```

This runs `claude mcp add xmlui -- xmlui.exe mcp` (skipping if already configured). After adding, tell the user they need to restart Claude Code for the MCP server to become active.

---

## Step 4: Download the weather app

Use AskUserQuestion to ask the user where to create the project. Offer `~/xmlui-weather` as the recommended default, and the current directory as an alternative. The user can also type a custom path.

Once you have the target path (resolve `~` to `$HOME` on macOS/Linux, or `%USERPROFILE%` on Windows), check if that directory already exists:

**macOS/Linux:**
```bash
test -d <target-path> && echo "exists" || echo "ok"
```

**Windows:**
```bash
Test-Path -LiteralPath "<target-path>"
```

If it exists, tell the user and stop — do not overwrite.

Otherwise, create the project at the chosen location:

**macOS/Linux:**
```bash
"${CLAUDE_PLUGIN_DATA}/bin/xmlui" new xmlui-weather --output <target-path>
```

**Windows:**
```bash
"${CLAUDE_SKILL_DIR}/scripts/dev-setup.cmd" -Template xmlui-weather -ProjectName <target-path>
```

Remember the chosen path — you will need it in Step 5.

---

## Step 5: Start the dev server

**macOS/Linux:**
```bash
cd <target-path> && "${CLAUDE_PLUGIN_DATA}/bin/xmlui" run
```

**Windows:**
```bash
cd <target-path> && xmlui.exe run
```

The dev server opens the app in the default browser automatically.

Tell the user:

> **Your XMLUI environment is ready.** See the [README](https://github.com/xmlui-org/xmlui-claude#readme) for a guided tour of the XMLUI MCP tools and the Inspector.
