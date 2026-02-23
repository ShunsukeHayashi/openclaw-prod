param(
  [Parameter(Mandatory=$true)][string]$SessionKey,
  [string]$StateDir = "C:\\Users\\shuns\\Dev\\openclaw-state",
  [string]$AgentId = "main",
  [switch]$RestartGateway
)

$ErrorActionPreference = "Stop"

$storePath = Join-Path $StateDir ("agents\\$AgentId\\sessions\\sessions.json")
if (!(Test-Path $storePath)) {
  throw "session store not found: $storePath"
}

# Backup
$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$bak = "$storePath.bak.$ts"
Copy-Item $storePath $bak -Force
Write-Host "Backed up: $bak" -ForegroundColor Cyan

$store = Get-Content $storePath -Raw | ConvertFrom-Json
$entry = $store.$SessionKey
if (-not $entry) {
  throw "sessionKey not found in store: $SessionKey"
}

# Remove override keys (last resort)
$keysToRemove = @(
  "providerOverride",
  "modelOverride",
  "authProfileOverride",
  "authProfileOverrideSource",
  "authProfileOverrideCompactionCount"
)

$removedAny = $false
foreach ($k in $keysToRemove) {
  if ($entry.PSObject.Properties.Name -contains $k) {
    $entry.PSObject.Properties.Remove($k)
    $removedAny = $true
  }
}

if (-not $removedAny) {
  Write-Host "No override keys present; nothing changed." -ForegroundColor Green
} else {
  # Write back (pretty JSON)
  $json = $store | ConvertTo-Json -Depth 30
  $tmp = "$storePath.$PID.$ts.tmp"
  Set-Content -Path $tmp -Value $json -Encoding UTF8
  Move-Item -Path $tmp -Destination $storePath -Force
  Write-Host "Overrides cleared for: $SessionKey" -ForegroundColor Green
}

if ($RestartGateway) {
  Write-Host "Restarting gateway..." -ForegroundColor Cyan
  & openclaw gateway restart
}

Write-Host "Done." -ForegroundColor Green
