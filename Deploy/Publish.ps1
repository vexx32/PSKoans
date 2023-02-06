[CmdletBinding()]
param(
    [string]
    $Key,

    [string]
    $Path,

    [string]
    $OutputDirectory
)

$env:NugetApiKey = $Key

if ($OutputDirectory) {
    Import-Module "$PSScriptRoot/PSKoans"
    $PSKoansModule = Get-Module -Name PSKoans

    $Dependencies = @()
    $PSKoansModule.RequiredModules | ForEach-Object {
        $Dependencies += @{
            Name = $_.Name
            Version = $_.Version
        }
    }
    $PSKoansModule.NestedModules | ForEach-Object {
        $Dependencies += @{
            Name = $_.Name
            Version = $_.Version
        }
    }
    
    foreach ($Module in $Dependencies) {
        Publish-Module -Name $Module.Name -RequiredVersion $Module.Version -Repository FileSystem -NugetApiKey "Test-Publish"
    }
}

$HelpFile = Get-ChildItem -Path "$PSScriptRoot/PSKoans" -File -Recurse -Filter '*-help.xml'

if ($HelpFile.Directory -notmatch 'en|\w{1,2}(-\w{1,2})?') {
    $PSCmdlet.WriteError(
        [System.Management.Automation.ErrorRecord]::new(
            [IO.FileNotFoundException]::new("Help files are missing!"),
            'Build.HelpXmlMissing',
            'ObjectNotFound',
            $null
        )
    )

    exit 404
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

$AzurePipelines = $env:BUILD_SOURCESDIRECTORY -and $env:BUILD_BUILDNUMBER
$GithubActions = [bool]$env:GITHUB_WORKSPACE

if ($AzurePipelines) {
    Write-Host "##vso[task.setvariable variable=NupkgPath]$Nupkg"
}

if ($GithubActions) {
    "NupkgPath=$Nupkg" | Add-Content -Path $env:GITHUB_ENV
}
