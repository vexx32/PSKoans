$Lines = '-' * 70

Import-Module 'PSKoans'

$PesterVersion = (Get-Module -Name Pester).Version
$PSVersion = $PSVersionTable.PSVersion

Write-Host $Lines
Write-Host "TEST: PowerShell Version: $PSVersion"
Write-Host "TEST: Pester Version: $PesterVersion"
Write-Host $Lines

try {
    # Try/Finally required since we will exit with exit code on failure.
    $configuration = [PesterConfiguration]::Default
    $configuration.Run.Path = "$env:PROJECTROOT/Tests"
    $configuration.Run.Exit = $true
    $configuration.CodeCoverage.Enabled = $true
    $configuration.CodeCoverage.Path = Get-ChildItem -Recurse -Include '*.ps1' -Path @(
            "$env:PROJECTROOT/PSKoans/PSKoans.psm1"
            "$env:PROJECTROOT/PSKoans/Public"
            "$env:PROJECTROOT/PSKoans/Private"
        ) | Select-Object -ExpandProperty FullName 
    $configuration.TestResult.Enabled = $true
    $configuration.TestResult.TestSuiteName = "PSKoans-Pester
    
    Invoke-Pester -Configuration $configuration
}
finally {
    $Timestamp = Get-Date -Format "yyyyMMdd-hhmmss"
    $TestFile = "PS${PSVersion}_${TimeStamp}_PSKoans.TestResults.xml"
    $CodeCoverageFile = "PS${PSVersion}_${TimeStamp}_PSKoans.CodeCoverage.xml"

    $ModuleFolders = @(
        Get-Item -Path "$env:PROJECTROOT/PSKoans"
        Get-ChildItem -Path "$env:PROJECTROOT/PSKoans" -Directory -Recurse |
            Where-Object FullName -NotMatch '[\\/]Tests[\\/]|[\\/]PSKoans[\\/]Koans[\\/]'
    ).FullName -join ';'

    # Tell Azure what the test results & code coverage file names will be
    Write-Host "##vso[task.setvariable variable=TestResults]$TestFile"
    Write-Host "##vso[task.setvariable variable=CodeCoverageFile]$CodeCoverageFile"
    Write-Host "##vso[task.setvariable variable=SourceFolders]$ModuleFolders"

    # Move files generated from Invoke-Pester to expected location
    Move-Item -Path './testResults.xml' -Destination "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$TestFile"
    Move-Item -Path './coverage.xml' -Destination "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$CodeCoverageFile"
}
