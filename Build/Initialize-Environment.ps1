Get-PackageProvider -Name NuGet -ForceBootstrap > $null

Set-BuildEnvironment

$ProjectRoot = Resolve-Path -Path "$PSScriptRoot/.."

$Lines = '-' * 70

Write-Host $Lines

$AzurePipelines = $env:BUILD_SOURCESDIRECTORY -and $env:BUILD_BUILDNUMBER
$GithubActions = [bool]$env:GITHUB_WORKSPACE

if ($AzurePipelines) {
    Write-Host "Repository Branch: [$env:BUILD_SOURCEBRANCHNAME] ($env:BUILD_SOURCEBRANCH)"
    Write-Host "##vso[task.setvariable variable=ProjectRoot]$ProjectRoot"
}
elseif ($GithubActions) {
    Write-Host "Repository Branch: $env:GITHUB_REF"
    if ($env:GITHUB_HEAD_REF -and $env:GITHUB_BASE_REF) {
        Write-Host "Pull Request Build: [$env:GITHUB_HEAD_REF] (HEAD) -> [$env:GITHUB_BASE_REF] (BASE)"
    }
    
    "PROJECTROOT=$ProjectRoot" | Add-Content -Path $env:GITHUB_ENV
}

Write-Host "Build System Details:"
Get-Item 'Env:BH*' | Out-String | Write-Host
Write-Host $Lines
