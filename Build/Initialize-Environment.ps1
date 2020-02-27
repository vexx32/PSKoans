Get-PackageProvider -Name NuGet -ForceBootstrap > $null

Set-BuildEnvironment

$ProjectRoot = Resolve-Path -Path "$PSScriptRoot/.."
Write-Host "##vso[task.setvariable variable=ProjectRoot]$ProjectRoot"

$Lines = '-' * 70

Write-Host $Lines
Write-Host "Repository Branch: $env:BUILD_SOURCEBRANCHNAME ($env:BUILD_SOURCEBRANCH)"
Write-Host "Build System Details:"
Get-Item 'Env:BH*' | Out-String | Write-Host
Write-Host $Lines
