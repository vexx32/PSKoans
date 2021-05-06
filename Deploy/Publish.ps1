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
    $Module = Get-Module -Name PSKoans
    $Dependencies = @(
        $Module.RequiredModules | Select-Object -Property Name, Version
        $Module.NestedModules | Select-Object -Property Name, Version
    ).Where{ $_ }

    foreach ($Module in $Dependencies) {
        Publish-Module -Name $Module.Name -Repository FileSystem -NugetApiKey "Test-Publish" -RequiredVersion $Module.Version
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
Write-Host "##vso[task.setvariable variable=NupkgPath]$Nupkg"
