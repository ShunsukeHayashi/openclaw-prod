param(
  [string]$SessionKey = "agent:main:main",
  [string]$StateDir = "C:\\Users\\shuns\\Dev\\openclaw-state",
  [string]$ConfigPath = "C:\\Users\\shuns\\Dev\\openclaw-state\\openclaw.json"
)

$ErrorActionPreference = "Stop"

Write-Host "== OpenClaw Prod Status ==" -ForegroundColor Cyan

# Version
try {
  $ver = (& openclaw --version) 2>$null
  Write-Host "OpenClaw: $ver"
} catch {
  Write-Host "OpenClaw: (unknown)" -ForegroundColor Yellow
}

# Global model routing
Write-Host "\n-- models status (global) --" -ForegroundColor Cyan
$env:OPENCLAW_STATE_DIR = $StateDir
$env:OPENCLAW_CONFIG_PATH = $ConfigPath
$modelsJson = & openclaw models status --json | ConvertFrom-Json
Write-Host "defaultModel : $($modelsJson.defaultModel)"
Write-Host "fallbacks    : $([string]::Join(' -> ', $modelsJson.fallbacks))"

# Session overrides
Write-Host "\n-- sessions (active) --" -ForegroundColor Cyan
$sessions = & openclaw sessions --json | ConvertFrom-Json
$entry = $sessions.sessions | Where-Object { $_.key -eq $SessionKey } | Select-Object -First 1
if (-not $entry) {
  Write-Host "No session entry found for key: $SessionKey" -ForegroundColor Yellow
  Write-Host "Known sessions:" -ForegroundColor Yellow
  $sessions.sessions | ForEach-Object { Write-Host ("- " + $_.key) }
  exit 0
}

Write-Host "sessionKey        : $($entry.key)"
Write-Host "sessionId         : $($entry.sessionId)"
Write-Host "providerOverride  : $($entry.providerOverride)"
Write-Host "modelOverride     : $($entry.modelOverride)"
Write-Host "model(resolved)   : $($entry.modelProvider)/$($entry.model)"
Write-Host "updatedAt         : $($entry.updatedAt)"

if ($entry.providerOverride -or $entry.modelOverride) {
  Write-Host ""
  Write-Host "############################################" -ForegroundColor Red
  Write-Host "  WARNING: session override is active" -ForegroundColor Red
  Write-Host "############################################" -ForegroundColor Red
  Write-Host ""
  Write-Host "--- Recommended Recovery Steps ---" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "Step 1 (Official CLI reset - try this first):" -ForegroundColor Green
  Write-Host "  openclaw sessions reset --key $SessionKey"
  Write-Host "  * If the subcommand is not recognized, your OpenClaw version" -ForegroundColor DarkGray
  Write-Host "    may not support it yet. Proceed to Step 2." -ForegroundColor DarkGray
  Write-Host ""
  Write-Host "Step 2 (JSON direct edit - last resort):" -ForegroundColor Magenta
  Write-Host "  .\scripts\oc-prod-reset-overrides.ps1 -SessionKey $SessionKey"
  Write-Host ""
  Write-Host "Step 3 (Optional - restart gateway if routing is stale):" -ForegroundColor Cyan
  Write-Host "  openclaw gateway restart"
  Write-Host ""
  Write-Host "After recovery, re-run this script to verify:" -ForegroundColor Cyan
  Write-Host "  .\scripts\oc-prod-status.ps1 -SessionKey $SessionKey"
}
