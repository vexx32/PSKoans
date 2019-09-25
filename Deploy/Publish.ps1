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

    Import-Module "$PSScriptRoot/FileSystem/PSKoans"
    $Module = Get-Module -Name PSKoans
    $Dependencies = @(
        $Module.RequiredModules.Name
        $Module.NestedModules.Name
    ).Where{ $_ }

    foreach ($Module in $Dependencies) {
        Publish-Module -Name $Module -Repository FileSystem -NugetApiKey "Test-Publish"
    }
}

$DeploymentParams = @{
    Path    = $Path
    Recurse = $false
    Force   = $true
    Verbose = $true
}

Invoke-PSDeploy @DeploymentParams

Get-ChildItem -Path $DeploymentParams['Path'] | Out-String | Write-Host

$Nupkg = Get-ChildItem -Path $DeploymentParams['Path'] -Filter 'PSKoans*.nupkg' | ForEach-Object FullName
Write-Host "##vso[task.setvariable variable=NupkgPath]$Nupkg"
