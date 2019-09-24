[CmdletBinding()]
param()
# Psake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    $ProjectRoot = Resolve-Path -Path "$PSScriptRoot/.."

    $Timestamp = Get-Date -Format "yyyyMMdd-hhmmss"
    $PSVersion = $PSVersionTable.PSVersion
    $TestFile = "PS${PSVersion}_${TimeStamp}_PSKoans.TestResults.xml"
    $CodeCoverageFile = "PS${PSVersion}_${TimeStamp}_PSKoans.CodeCoverage.xml"
    $ModuleFolders = @(
        Get-ChildItem -Path "$ProjectRoot/PSKoans" -Directory -Recurse |
            Where-Object { 'Koans' -notin $_.Parent.Name, $_.Parent.Parent.Name }
    ).FullName -join ';'
    $Lines = '-' * 70

    $Continue = @{
        InformationAction = if ($PSBoundParameters['InformationAction']) {
            $PSBoundParameters['InformationAction']
        }
        else {
            'Continue'
        }
    }
}

Task 'Default' -Depends 'Test'

Task 'Init' {
    Set-Location -Path $ProjectRoot

    Write-Information @Continue @"
$Lines
Repository Branch: $env:BUILD_SOURCEBRANCHNAME ($env:BUILD_SOURCEBRANCH)

Build System Details:
"@
    Get-Item 'ENV:BH*'
}

Task 'Test' -Depends 'Init' {
    Write-Information @Continue @"
$Lines
STATUS: Testing with PowerShell $PSVersion
"@
    # Testing links on github requires >= tls 1.2
    $SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Import the module and add temporary entry to PSModulePath for build/test purposes
    $env:PSModulePath = '{0}{1}{2}' -f $ProjectRoot, ([System.IO.Path]::PathSeparator), $env:PSModulePath
    Import-Module 'PSKoans'

    # Tell Azure where the test results & code coverage files will be
    Write-Host "##vso[task.setvariable variable=TestResults]$TestFile"
    Write-Host "##vso[task.setvariable variable=CodeCoverageFile]$CodeCoverageFile"
    Write-Host "##vso[task.setvariable variable=SourceFolders]$ProjectRoot/PSKoans;$ModuleFolders"

    # Gather test results. Store them in a variable and file
    $PesterParams = @{
        Path                   = "$ProjectRoot/Tests"
        PassThru               = $true
        OutputFormat           = 'NUnitXml'
        OutputFile             = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$TestFile"
        Show                   = "Header", "Failed", "Summary"
        CodeCoverage           = (Get-ChildItem -Recurse -Path "$ProjectRoot/PSKoans" -Filter '*.ps*1' -Exclude '*.Koans.ps1').FullName
        CodeCoverageOutputFile = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY/$CodeCoverageFile"
    }
    $TestResults = Invoke-Pester @PesterParams

    [Net.ServicePointManager]::SecurityProtocol = $SecurityProtocol

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed $($TestResults.FailedCount) tests; build failed!"
    }
}

Task 'Build' -Depends 'Test' {
    Write-Information @Continue @"

$Lines
"@
    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunction

    # Bump the module version if we didn't already
    try {
        $GalleryVersion = Get-NextNugetPackageVersion -Name $env:BHProjectName -ErrorAction Stop
        $GithubVersion = Get-MetaData -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop
        if ($GalleryVersion -ge $GithubVersion) {
            Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $GalleryVersion -ErrorAction stop
        }
    }
    catch {
        Write-Information @Continue @"
Failed to update version for '$env:BHProjectName': $_.
Continuing with existing version.
"@
    }

    # Build external help files from Platyps MD files
    New-ExternalHelp -Path "$ProjectRoot/docs/" -OutputPath "$ProjectRoot/PSKoans/en-us"
}
