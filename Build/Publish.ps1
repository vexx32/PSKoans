param($Key)

$ENV:NugetApiKey = $Key

$DeploymentParams = @{
    Path    = Resolve-Path "$PSScriptRoot/../"
    Recurse = $false
    Force   = $true
    Verbose = $true
}

Get-ChildItem -Path $DeploymentParams['Path'] | Write-Host

Invoke-PSDeploy @DeploymentParams