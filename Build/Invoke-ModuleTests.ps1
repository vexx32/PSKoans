$Lines = '-' * 70

Import-Module 'PSKoans'

$PesterVersion = (Get-Module -Name Pester).Version
$PSVersion = $PSVersionTable.PSVersion

Write-Host $Lines
Write-Host "TEST: PowerShell Version: $PSVersion"
Write-Host "TEST: Pester Version: $PesterVersion"
Write-Host $Lines

try {
    # Try/Finally required since -CI will exit with exit code on failure.
    Invoke-Pester -Path "$env:PROJECTROOT/Tests" -CI -Output Normal
}
finally {
    $Timestamp = Get-Date -Format "yyyyMMdd-hhmmss"
    $TestFile = "PS${PSVersion}_${TimeStamp}_PSKoans.TestResults.xml"
    $CodeCoverageFile = "PS${PSVersion}_${TimeStamp}_PSKoans.CodeCoverage.xml"

    # Tell Azure what the test results & code coverage file names will be
    Write-Host "##vso[task.setvariable variable=TestResults]$TestFile"
    Write-Host "##vso[task.setvariable variable=CodeCoverageFile]$CodeCoverageFile"

    # Move files generated from Invoke-Pester to expected location
    Move-Item -Path './testResults.xml' -Destination "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$TestFile"
    Move-Item -Path './coverage.xml' -Destination "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$CodeCoverageFile"
}
