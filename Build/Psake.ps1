[CmdletBinding()]
param()
# Psake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
    $ProjectRoot = $env:BHProjectPath
    if (-not $ProjectRoot) {
        $ProjectRoot = Resolve-Path -Path "$PSScriptRoot\.."
    }

    $Timestamp = Get-Date -Format "yyyyMMdd-hhmmss"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS${PSVersion}_${TimeStamp}.xml"
    $Lines = '-' * 70

    $DeploymentParams = @{
        Path    = "$ProjectRoot"
        Force   = $true
        Recurse = $false # We keep psdeploy artifacts, avoid deploying those
    }
    if ($ENV:BHCommitMessage -match "!verbose") {
        $DeploymentParams.Add('Verbose', $true)
    }

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
    Write-Information $Lines @Continue
    Set-Location -Path $ProjectRoot
    Write-Information "Build System Details:" @Continue
    Get-Item ENV:BH*
    Write-Information "`n" @Continue
}

Task 'Test' -Depends 'Init' {
    Write-Information $Lines @Continue
    Write-Information "`n`tSTATUS: Testing with PowerShell $PSVersion" @Continue

    # Testing links on github requires >= tls 1.2
    $SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Gather test results. Store them in a variable and file
    $PesterParams = @{
        Path         = "$ProjectRoot\Tests"
        PassThru     = $true
        OutputFormat = 'NUnitXml'
        OutputFile   = "$ProjectRoot\$TestFile"
    }
    $TestResults = Invoke-Pester @PesterParams
    [Net.ServicePointManager]::SecurityProtocol = $SecurityProtocol

    # In Appveyor?  Upload our tests!
    If ($ENV:BHBuildSystem -eq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile"
        )
    }

    Remove-Item -Path "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests; build failed!"
    }
    Write-Information "`n" @Continue
}

Task 'Build' -Depends 'Test' {
    Write-Information $Lines @Continue

    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions

    # Bump the module version if we didn't already
    try {
        $GalleryVersion = Get-NextNugetPackageVersion -Name $env:BHProjectName -ErrorAction Stop
        $GithubVersion = Get-MetaData -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -ErrorAction Stop
        if ($GalleryVersion -ge $GithubVersion) {
            Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $GalleryVersion -ErrorAction stop
        }
    }
    catch {
        Write-Information "Failed to update version for '$env:BHProjectName': $_." @Continue
        Write-Information "Continuing with existing version" @Continue
    }
}

Task Deploy -Depends Build {
    Write-Information $Lines @Continue

    Invoke-PSDeploy @DeploymentParams
}