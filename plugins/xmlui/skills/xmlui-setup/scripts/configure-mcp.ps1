Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/common.ps1"

Write-Log "Configuring XMLUI MCP server for Claude"

$xmluiCmd = Get-XmluiCommand
if (-not $xmluiCmd) {
  Fail "XMLUI CLI not on PATH. Run install-cli first."
}

$claudeListOutput = & (Get-ClaudeCommand) mcp list 2>&1
if ($claudeListOutput -match "xmlui") {
  Write-Log "MCP server 'xmlui' already configured"
  exit 0
}

$xmluiExe = (Get-Command "xmlui.exe" -ErrorAction SilentlyContinue)
$xmluiExePath = if ($xmluiExe) { $xmluiExe.Source } else { $null }

$addAttempts = @(
  @("mcp", "add", "xmlui", "--", "xmlui", "mcp"),
  @("mcp", "add", "xmlui", "--", "xmlui.exe", "mcp")
)
if ($xmluiExePath) {
  $addAttempts += ,@("mcp", "add", "xmlui", "--", $xmluiExePath, "mcp")
}

$added = $false
foreach ($attempt in $addAttempts) {
  $null = Invoke-Claude @attempt
  if ($LASTEXITCODE -eq 0) {
    Write-Log "MCP server 'xmlui' configured"
    $added = $true
    break
  }
}

if (-not $added) {
  Fail "Failed to configure MCP with 'claude mcp add'."
}

$verifyOutput = & (Get-ClaudeCommand) mcp list 2>&1
if ($verifyOutput -match "xmlui") {
  Write-Log "Verified MCP server 'xmlui'"
} else {
  Fail "MCP server 'xmlui' not found after add attempt"
}
