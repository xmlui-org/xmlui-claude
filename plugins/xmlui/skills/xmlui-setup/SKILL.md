---
name: xmlui-setup
description: Set up a complete XMLUI development environment. Use when the user wants to start XMLUI development, install the XMLUI CLI, configure the MCP server, or create a new XMLUI project.
disable-model-invocation: true
allowed-tools: Bash, Read, Edit, Write, AskUserQuestion
---

# XMLUI Development Environment Setup

`xmlui-setup` downloads the `xmlui-weather` app (which includes the Inspector for debugging) and starts a local webserver to run the app. The XMLUI CLI is auto-installed by the MCP server wrapper on first use.

Run every step automatically — do not ask the user for confirmation between steps.

---

## Step 1: Preflight

Run:

```bash
"${CLAUDE_SKILL_DIR}/scripts/preflight.sh"
```

If it fails, tell the user what to install and stop. Do not proceed until preflight passes.

---

## Step 2: Ensure the CLI is available

The MCP server's `.mcp.json` auto-downloads the CLI on first use. Verify it's ready:

```bash
"${CLAUDE_PLUGIN_DATA}/bin/xmlui" --help
```

If this fails, install manually:

```bash
CLAUDE_PLUGIN_DATA="${CLAUDE_PLUGIN_DATA}" "${CLAUDE_SKILL_DIR}/scripts/install-cli.sh"
```

---

## Step 3: MCP server

The MCP server is configured automatically via the plugin's `.mcp.json` and auto-installs the CLI binary on first use. No manual setup or extra restart needed.

---

## Step 4: Download the weather app

Use AskUserQuestion to ask the user where to create the project. Offer `~/xmlui-weather` as the recommended default, and the current directory as an alternative. The user can also type a custom path.

Once you have the target path (resolve `~` to `$HOME`), check if that directory already exists:

```bash
test -d <target-path> && echo "exists" || echo "ok"
```

If it exists, tell the user and stop — do not overwrite.

Otherwise, create the project at the chosen location:

```bash
"${CLAUDE_PLUGIN_DATA}/bin/xmlui" new xmlui-weather --output <target-path>
```

Remember the chosen path — you will need it in Step 5.

---

## Step 5: Start the dev server

```bash
cd <target-path> && "${CLAUDE_PLUGIN_DATA}/bin/xmlui" run
```

The dev server opens the app in the default browser automatically.

Tell the user:

> **Your XMLUI environment is ready.** See the [README](https://github.com/xmlui-org/xmlui-claude#readme) for a guided tour of the XMLUI MCP tools and the Inspector.
