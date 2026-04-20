# Fresh start

These instructions assume you have Claude Code installed and running. If not, see the [quickstart](https://code.claude.com/docs/en/quickstart).

## 1. Remove any previous installation

If you've installed the xmlui plugin before, remove it cleanly:

```
/plugin uninstall xmlui@xmlui-claude
/plugin marketplace remove xmlui-claude
```

Then delete the cached plugin data, directories, and registry entries:

```bash
rm -rf ~/.claude/plugins/data/xmlui-xmlui-claude
rm -rf ~/.claude/plugins/cache/xmlui-claude
rm -rf ~/.claude/plugins/marketplaces/xmlui-claude
rm -rf ~/.claude/plugins/marketplaces/xmlui-org-xmlui-claude
```

Also clear the registry files so the plugin system doesn't re-sync stale entries:

```bash
echo '{}' > ~/.claude/plugins/known_marketplaces.json
```

```bash
echo '{"version":2,"plugins":{}}' > ~/.claude/plugins/installed_plugins.json
```

Restart Claude Code.

## 2. Add the marketplace

```
/plugin marketplace add xmlui-org/xmlui-claude
```

Expected output:
```
⎿  Successfully added marketplace: xmlui-claude
```

## 3. Install the plugin

```
/plugin install xmlui@xmlui-claude
```

When prompted for install scope, choose the default: **Install for you (user scope)**. This makes the plugin available across all your projects.

Expected output:
```
⎿  ✓ Installed xmlui. Run /reload-plugins to apply.
```

**Restart Claude Code.** The plugin's MCP server and skill require a fresh session to load.

## 4. Run the setup skill

Navigate to the directory where you want your project created, then:

```
/xmlui:xmlui-setup
```

The skill will:

1. **Preflight** — check that `curl`, `tar`, etc. are available
2. **Deploy the wrapper script** — copies the lazy-install wrapper to the plugin data directory. The wrapper auto-downloads the CLI binary on first use.
3. **Confirm the MCP server** — the plugin's `.mcp.json` auto-registers the MCP server via the wrapper. No manual `claude mcp add` needed, and no second restart required.
4. **Create the weather app** — scaffolds `xmlui-weather` in the current directory
5. **Start the dev server** — runs `xmlui run` (usually on port 8080)

Open a browser to the indicated port. You should see the Weather Dashboard with a magnifying glass icon in the top right — that's the Inspector.

No additional restart is needed — the MCP server uses the wrapper script, which auto-installs the CLI binary.

## 5. Verify the MCP server

Ask Claude something like:

```
how does DataSource work?
```

Claude should call MCP tools like `xmlui_component_docs` or `xmlui_search` rather than guessing. If XMLUI MCP tools don't appear, check:

```
/plugin list
```

`xmlui@xmlui-claude` should be listed. If not, repeat from step 2.

## Updating

To pull the latest plugin version:

```
/plugin marketplace update xmlui-claude
/plugin update xmlui@xmlui-claude
```

Restart Claude Code after updating.

## What gets installed where

| What | Where |
|------|-------|
| Marketplace metadata | `~/.claude/plugins/cache/xmlui-claude/` |
| Plugin files | `~/.claude/plugins/cache/xmlui-claude/xmlui/<version>/` |
| CLI binary | `~/.claude/plugins/data/xmlui-xmlui-claude/bin/xmlui` |
| MCP server | Runs via the CLI: `xmlui mcp` (auto-registered by `.mcp.json`) |
| Project files | Wherever you ran `/xmlui:xmlui-setup` |
