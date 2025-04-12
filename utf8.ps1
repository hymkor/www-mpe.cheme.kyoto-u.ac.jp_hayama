$sourceRoot = Get-Location
$targetRoot = Join-Path $sourceRoot "docs"

Get-ChildItem -Recurse -File | Where-Object {
    -not $_.FullName.StartsWith((Join-Path $sourceRoot "docs")) -and
    -not $_.Name.StartsWith(".") -and
    -not $_.Name.EndsWith(".ps1")
} | ForEach-Object {
    $sourceFile = $_.FullName
    $relativePath = $sourceFile.Substring($sourceRoot.Path.Length).TrimStart('\', '/')
    $targetFile = Join-Path $targetRoot $relativePath

    $targetDir = Split-Path $targetFile
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    Write-Host "$sourceFile`n-> $targetFile"
    if ($sourceFile -match '\.html?$') {
        nkf32 -J -w8 $sourceFile > $targetFile
    } else {
        Copy-Item $sourceFile $targetFile -Force
    }
} | Out-Null
