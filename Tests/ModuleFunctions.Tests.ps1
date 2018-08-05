$ProjectRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests'
$ModuleFolder = "$ProjectRoot\PSKoans"
Import-Module $ModuleFolder -Prefix "TST"

if (-not $env:APPVEYOR_BUILD_FOLDER) {
    $env:APPVEYOR_BUILD_FOLDER = (Get-Module -Name 'PSKoans').ModuleBase
}






