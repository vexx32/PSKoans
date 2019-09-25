[CmdletBinding()]
param(
    [string]
    $Key,

    [string]
    $Path,

    [string]
    $OutputDirectory
)

$ENV:NugetApiKey = $Key

if ($OutputDirectory) {
    $Params = @{
        Name                 = 'FileSystem'
        SourceLocation       = "$PSScriptRoot/FileSystem"
        ScriptSourceLocation = "$PSScriptRoot/FileSystem"
        InstallationPolicy   = 'Trusted'
    }
    Register-PSRepository @Params
}

$DeploymentParams = @{
    Path    = $Path
    Recurse = $false
    Force   = $true
    Verbose = $true
}

Get-ChildItem -Path $DeploymentParams['Path'] | Write-Host

Invoke-PSDeploy @DeploymentParams
