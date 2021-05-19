# Grab nuget bits, set build variables, start build.
Get-PackageProvider -Name NuGet -ForceBootstrap > $null

# Create format.ps1xml file
& "$PSScriptRoot/../PSKoans.ezformat.ps1"

if ($env:PROJECTROOT) {
    Import-Module "$env:PROJECTROOT/PSKoans"
}
elseif ($env:GITHUB_WORKSPACE) {
    Import-Module "$env:GITHUB_WORKSPACE/PSKoans"
}
else {
    Import-Module "./PSKoans"
}

Set-BuildEnvironment

$Lines = '-' * 70

Write-Host $Lines
Write-Host "STATUS: Generating External Help and Building Module"
Write-Host $Lines

# Load the module, read the exported functions, update the psd1 FunctionsToExport
Set-ModuleFunction

# Bump the module version if we didn't already
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $GalleryVersion = Get-NextNugetPackageVersion -Name $env:BHProjectName -ErrorAction Stop
    $GithubVersion = Get-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop

    if ($GalleryVersion -ge $GithubVersion) {
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $GalleryVersion -ErrorAction Stop
    }
}
catch {
    Write-Host "Failed to update version for '$env:BHProjectName': $_."
    Write-Host "Continuing with existing version."
}

# Build external help files from Platyps MD files
New-ExternalHelp -Path "$env:PROJECTROOT/docs/" -OutputPath "$env:PROJECTROOT/PSKoans/en"

Copy-Item -Path "$env:PROJECTROOT/PSKoans" -Destination $env:BUILTMODULEPATH -Recurse -PassThru |
    Where-Object { -not $_.PSIsContainer }
