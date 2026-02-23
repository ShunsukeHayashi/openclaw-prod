param(
  [string]$StateDir = "C:\\Users\\shuns\\Dev\\openclaw-state",
  [string]$AgentId = "main"
)

$ErrorActionPreference = "Stop"

$storePath = Join-Path $StateDir ("agents\\$AgentId\\sessions\\sessions.json")
if (!(Test-Path $storePath)) {
  throw "session store not found: $storePath"
}

$store = Get-Content $storePath -Raw | ConvertFrom-Json

$overridden = @()
foreach ($p in $store.PSObject.Properties) {
  $key = $p.Name
  $e = $p.Value
  if ($null -ne $e.providerOverride -or $null -ne $e.modelOverride -or $null -ne $e.authProfileOverride) {
    $overridden += [pscustomobject]@{
      sessionKey = $key
      providerOverride = $e.providerOverride
      modelOverride = $e.modelOverride
      authProfileOverride = $e.authProfileOverride
      updatedAt = $e.updatedAt
    }
  }
}

if ($overridden.Count -eq 0) {
  Write-Host "No session overrides found." -ForegroundColor Green
  exit 0
}

Write-Host "Overrides found:" -ForegroundColor Yellow
$overridden | Sort-Object updatedAt -Descending | Format-Table -AutoSize
