$Lines = '-' * 70
$PSVersion = $PSVersionTable.PSVersion

Write-Host $Lines
Write-Host "STATUS: Testing with PowerShell v$($PSVersionTable.PSVersion)"
Write-Host $Lines

# Import the module and add temporary entry to PSModulePath for build/test purposes

Import-Module 'PSKoans'

$Timestamp = Get-Date -Format "yyyyMMdd-hhmmss"
$TestFile = "PS${PSVersion}_${TimeStamp}_PSKoans.TestResults.xml"
$CodeCoverageFile = "PS${PSVersion}_${TimeStamp}_PSKoans.CodeCoverage.xml"

$ModuleFolders = @(
    Get-Item -Path "$env:PROJECTROOT/PSKoans"
    Get-ChildItem -Path "$env:PROJECTROOT/PSKoans" -Directory -Recurse |
        Where-Object { 'Koans' -notin $_.Parent.Name, $_.Parent.Parent.Name }
).FullName -join ';'

# Tell Azure where the test results & code coverage files will be
Write-Host "##vso[task.setvariable variable=TestResults]$TestFile"
Write-Host "##vso[task.setvariable variable=CodeCoverageFile]$CodeCoverageFile"
Write-Host "##vso[task.setvariable variable=SourceFolders]$ModuleFolders"

# Gather test results. Store them in a variable and file
$PesterParams = @{
    Path                   = "$env:PROJECTROOT/Tests"
    PassThru               = $true
    OutputFormat           = 'NUnitXml'
    OutputFile             = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$TestFile"
    Show                   = "Header", "Failed", "Summary"
    CodeCoverage           = (Get-ChildItem -Recurse -Path "$env:PROJECTROOT/PSKoans" -Filter '*.ps*1' -Exclude '*.Koans.ps1').FullName
    CodeCoverageOutputFile = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$CodeCoverageFile"
}
$TestResults = Invoke-Pester @PesterParams

# If tests failed, write errors and exit
if ($TestResults.FailedCount -gt 0) {
    Write-Error "Failed $($TestResults.FailedCount) tests; build failed!"
    exit $TestResults.FailedCount
}
