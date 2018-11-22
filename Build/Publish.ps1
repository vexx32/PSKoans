param($Key)

$ENV:NugetApiKey = $Key

$DeploymentParams = @{
    Path    = Resolve-Path "$PSScriptRoot/../"
    Recurse = $false
    Force   = $true
    Verbose = $true
}

Invoke-PSDeploy @DeploymentParams