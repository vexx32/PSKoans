param (
    [string[]]
    $Task = 'Default'
)

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap > $null

Install-Module Psake, PSDeploy, BuildHelpers -Force -Scope CurrentUser
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser
Import-Module Psake, BuildHelpers

Set-BuildEnvironment

Invoke-Psake -BuildFile "$PSScriptRoot\psake.ps1" -TaskList $Task -NoLogo

exit ([int](-not $Psake.Build_Success))