#Requires -Modules EZOut
# Install-Module EZOut or https://github.com/StartAutomating/EZOut

$ModuleName = $($PSCommandPath | Split-Path -Leaf) -replace '\.ezformat\.ps1', ''

try {
    Push-Location $PSScriptRoot

    $formatting = @(
        # Add your own Write-FormatView here, or put them in a Formatting or Views directory

        foreach ($potentialDirectory in 'Formatting', 'Views') {
            $path = Join-Path $PSScriptRoot -ChildPath $potentialDirectory
            if (Test-Path $path) {
                Get-ChildItem -Path $path | Import-FormatView -FilePath { $_.FullName }
            }
        }
    )

    $ModuleFolder = "$PSScriptRoot/PSKoans"
    if ($formatting) {
        $FormatFile = Join-Path $ModuleFolder -ChildPath "$ModuleName.format.ps1xml"
        $formatting | Out-FormatData -Module $ModuleName | Set-Content $FormatFile -Encoding UTF8
    }

    $types = @(
        # Add your own Write-TypeView statements here
    )

    if ($types) {
        $TypesFile = Join-Path $PSScriptRoot "$ModuleName.types.ps1xml"
        $types | Out-TypeData | Set-Content $TypesFile -Encoding UTF8
    }
}
finally {
    Pop-Location
}
