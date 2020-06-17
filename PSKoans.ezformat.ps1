#requires -Module EZOut
#  Install-Module EZOut or https://github.com/StartAutomating/EZOut
$myFile = $MyInvocation.MyCommand.ScriptBlock.File
$myModuleName = 'PSKoans'
$myRoot = "$PSScriptRoot"
Push-Location $myRoot
$formatting = @(
    # Add your own Write-FormatView here,
    # or put them in a Formatting or Views directory
    foreach ($potentialDirectory in 'formatting', 'views') {
        Join-Path $myRoot -ChildPath $potentialDirectory |
            Get-ChildItem -ea ignore |
            Import-FormatView -FilePath { $_.Fullname }
    }
)

$destinationRoot = "$PSScriptRoot/PSKoans"

if ($formatting) {
    $myFormatFile = Join-Path $destinationRoot "$myModuleName.format.ps1xml"
    $formatting | Out-FormatData -Module $MyModuleName | Set-Content $myFormatFile -Encoding UTF8
}

$types = @(
    # Add your own Write-TypeView statements here
    # or declare them in the 'Types' directory
    Join-Path $myRoot Types |
        Get-Item -ea ignore |
        Import-TypeView

)

if ($types) {
    $myTypesFile = Join-Path $destinationRoot "$myModuleName.types.ps1xml"
    $types | Out-TypeData | Set-Content $myTypesFile -Encoding UTF8
}
Pop-Location
