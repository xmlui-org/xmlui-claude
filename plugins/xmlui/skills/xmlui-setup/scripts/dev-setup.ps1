param(
  [string]$Template = "xmlui-weather",
  [string]$ProjectName = "xmlui-weather"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/common.ps1"

$xmluiPath = if ($env:CLAUDE_PLUGIN_DATA) {
  Join-Path $env:CLAUDE_PLUGIN_DATA "bin\xmlui.exe"
} else {
  $cmd = Get-XmluiCommand
  if ($cmd) { (Get-Command $cmd -ErrorAction SilentlyContinue).Source } else { $null }
}

if (-not $xmluiPath -or -not (Test-Path -LiteralPath $xmluiPath -ErrorAction SilentlyContinue)) {
  Fail "xmlui CLI is not available. Run install-cli first."
}

if (Test-Path -LiteralPath $ProjectName) {
  Write-WarnLog "Directory '$ProjectName' already exists. Skipping project init."
  exit 0
}

Write-Log "Creating project: xmlui new $Template --output $ProjectName"
& $xmluiPath new $Template --output $ProjectName
if ($LASTEXITCODE -ne 0) {
  Fail "Project creation failed."
}

Write-Log "Project ready: $ProjectName"
Write-Log "To start the dev server, run:"
Write-Log "  cd $ProjectName"
Write-Log "  xmlui run"
