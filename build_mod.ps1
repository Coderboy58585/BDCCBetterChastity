$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dist = Join-Path $root "dist"
$out = Join-Path $dist "BDCCBetterChastity.zip"
$stage = Join-Path $dist "_stage"

if (!(Test-Path $dist)) {
    New-Item -ItemType Directory -Path $dist | Out-Null
}

if (Test-Path $out) {
    Remove-Item -LiteralPath $out -Force
}

if (Test-Path $stage) {
    Remove-Item -LiteralPath $stage -Recurse -Force
}

New-Item -ItemType Directory -Path $stage | Out-Null
Copy-Item -Path (Join-Path $root "Modules") -Destination $stage -Recurse
Copy-Item -Path (Join-Path $root "BDCCBetterChastity.json") -Destination $stage

Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $out -Force
Remove-Item -LiteralPath $stage -Recurse -Force
Write-Host "Built $out"
