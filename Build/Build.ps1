param(
    [string]
    $ApiKey,

    [string[]]
    $Task = 'Default'
)

if ($ApiKey) {
    $env:NugetApiKey = $ApiKey
}

# Grab nuget bits, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap > $null

Import-Module -Name Psake, BuildHelpers

Set-BuildEnvironment

Invoke-Psake -BuildFile "$PSScriptRoot\psake.ps1" -TaskList $Task -NoLogo

exit ([int](-not $Psake.Build_Success))