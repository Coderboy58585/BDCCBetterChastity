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

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Add-ZipFile {
    param(
        [System.IO.Compression.ZipArchive]$Archive,
        [string]$FilePath,
        [string]$EntryName
    )

    $normalizedEntry = $EntryName.Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $Archive,
        $FilePath,
        $normalizedEntry,
        [System.IO.Compression.CompressionLevel]::Optimal
    ) | Out-Null
}

$archive = [System.IO.Compression.ZipFile]::Open($out, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Add-ZipFile -Archive $archive -FilePath (Join-Path $root "BDCCBetterChastity.json") -EntryName "BDCCBetterChastity.json"

    $modulesRoot = Join-Path $root "Modules"
    Get-ChildItem -LiteralPath $modulesRoot -Recurse -File | ForEach-Object {
        $relativePath = $_.FullName.Substring($root.Length + 1)
        Add-ZipFile -Archive $archive -FilePath $_.FullName -EntryName $relativePath
    }
}
finally {
    $archive.Dispose()
}

Write-Host "Built $out"
