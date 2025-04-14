function mirror($src,$dst){
    Get-ChildItem -Path $src | ForEach-Object {
        $name = $_.Name
        if ( $name.StartsWith(".") -or $name -in @("docs","utf8.ps1") ){
            return
        }
        $newname = (Join-Path -Path $dst -ChildPath $name)
        Write-Host ("{0}`n-> {1}" -f $_.FullName,$newname)
        if ( $_.PSIsContainer ){
            if ( -not (Test-Path $newname) ){
                New-Item -Path $newname -ItemType "Directory"
            }
            mirror ($_.FullName) $newname
        } else {
            if ($name -match '\.html?$') {
                nkf32 -w $_.FullName | perl -pe 'binmode(STDIN);binmode(STDOUT);s|"/image/|"/www-mpe.cheme.kyoto-u.ac.jp_hayama/img/|g' > $newname

            } else {
                Copy-Item $_.FullName $newname -Force
            }
        }
    } | Out-Null
}

$src = (Get-Location)
$dst = (Join-Path -Path $src -ChildPath "docs")
mirror $src $dst
