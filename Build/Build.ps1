param (
    [string[]]
    $Task = 'Default'
)

if ($env:APPVEYOR_REPO_BRANCH -eq 'master' -and -not $env:APPVEYOR_PULL_REQUEST_NUMBER) {
    $Task = 'Deploy'
}

# Grab nuget bits, install modules, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap > $null

Install-Module -Name Psake, PSDeploy, BuildHelpers -Force -Scope CurrentUser
Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
Import-Module -Name Psake, BuildHelpers

Set-BuildEnvironment

Invoke-Psake -BuildFile "$PSScriptRoot\psake.ps1" -TaskList $Task -NoLogo

exit ([int](-not $Psake.Build_Success))