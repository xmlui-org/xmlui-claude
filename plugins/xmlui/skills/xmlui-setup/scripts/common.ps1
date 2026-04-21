Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Log {
  param([Parameter(Mandatory = $true)][string]$Message)
  Write-Host "[xmlui-claude] $Message"
}

function Write-WarnLog {
  param([Parameter(Mandatory = $true)][string]$Message)
  Write-Warning "[xmlui-claude] $Message"
}

function Fail {
  param([Parameter(Mandatory = $true)][string]$Message)
  throw "[xmlui-claude] ERROR: $Message"
}

function Require-Command {
  param([Parameter(Mandatory = $true)][string]$Name)
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if (-not $cmd) {
    Fail "Missing required command: $Name"
  }
}

function Get-ClaudeCommand {
  $candidates = @("claude.cmd", "claude")
  foreach ($candidate in $candidates) {
    $cmd = Get-Command $candidate -ErrorAction SilentlyContinue
    if ($cmd) {
      return $candidate
    }
  }
  Fail "Claude CLI not found. Install Claude Code and ensure claude/claude.cmd is on PATH."
}

function Get-XmluiCommand {
  $candidates = @("xmlui.exe", "xmlui.cmd", "xmlui")
  foreach ($candidate in $candidates) {
    $cmd = Get-Command $candidate -ErrorAction SilentlyContinue
    if ($cmd) {
      return $candidate
    }
  }
  return $null
}

function Invoke-Claude {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
  $claudeCmd = Get-ClaudeCommand
  & $claudeCmd @Args
  return $LASTEXITCODE
}

function Invoke-Xmlui {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Args)
  $xmluiCmd = Get-XmluiCommand
  if (-not $xmluiCmd) {
    Fail "XMLUI CLI is not available on PATH."
  }
  & $xmluiCmd @Args
  return $LASTEXITCODE
}
