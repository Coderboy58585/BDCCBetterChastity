$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dist = Join-Path $root "dist"
$out = Join-Path $dist "BDCCBetterChastity.zip"

if (!(Test-Path $dist)) {
    New-Item -ItemType Directory -Path $dist | Out-Null
}

if (Test-Path $out) {
    Remove-Item -LiteralPath $out -Force
}

Compress-Archive -Path (Join-Path $root "Modules") -DestinationPath $out -Force
Write-Host "Built $out"
