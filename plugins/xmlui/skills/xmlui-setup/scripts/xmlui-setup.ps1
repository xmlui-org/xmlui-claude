param(
  [switch]$CreateProject,
  [string]$Template = "xmlui-weather",
  [string]$ProjectName = "xmlui-weather"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

& (Join-Path $scriptRoot "preflight.ps1")

$xmluiExePath = if ($env:CLAUDE_PLUGIN_DATA) {
  Join-Path $env:CLAUDE_PLUGIN_DATA "bin\xmlui.exe"
} else {
  $cmd = Get-Command "xmlui.exe" -ErrorAction SilentlyContinue
  if ($cmd) { $cmd.Source } else { $null }
}

if (-not $xmluiExePath -or -not (Test-Path -LiteralPath $xmluiExePath -ErrorAction SilentlyContinue)) {
  & (Join-Path $scriptRoot "install-cli.ps1")
}

& (Join-Path $scriptRoot "configure-mcp.ps1")

if ($CreateProject) {
  & (Join-Path $scriptRoot "dev-setup.ps1") -Template $Template -ProjectName $ProjectName
}
