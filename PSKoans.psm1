function Get-Enlightenment {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default")]
    [Alias('Rake', 'Invoke-PSKoans', 'Test-Koans')]
    param(
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNull()]
        [bool]
        $Clear = $true,

        [Parameter(Mandatory, ParameterSetName = "Meditate")]
        [switch]
        $Meditate,

        [Parameter(Mandatory, ParameterSetName = "Reset")]
        [switch]
        $Reset
    )
    switch ($PSCmdlet.ParameterSetName) {
        "Reset" {
            Initialize-KoanDirectory
        }
        "Meditate" {
            Invoke-Item $script:KoanFolder
        }
        "Default" {
            if ($Clear) {Clear-Host}
            Write-MeditationPrompt -Greeting

            $PesterTestCount = Invoke-Pester -Script $script:KoanFolder -PassThru -Show None |
                Select-Object -ExpandProperty TotalCount

            $Tests = Get-ChildItem -Path $script:KoanFolder -Filter '*.Tests.ps1' -Recurse
            $KoansPassed = 0

            foreach ($KoanFile in $Tests) {
                $PesterTests = Invoke-Pester -PassThru -Show None -Script $KoanFile.FullName
                $KoansPassed += $PesterTests.PassedCount

                if ($PesterTests.FailedCount -gt 0) {
                    break
                }
            }

            if ($PesterTests.FailedCount -gt 0) {
                $NextKoanFailed = $PesterTests.TestResult |
                    Where-Object Result -eq 'Failed' |
                    Select-Object -First 1

                $Meditation = @{
                    DescribeName = $NextKoanFailed.Describe
                    Expectation  = $NextKoanFailed.ErrorRecord
                    ItName       = $NextKoanFailed.Name
                    Meditation   = $NextKoanFailed.StackTrace
                    KoansPassed  = $KoansPassed
                    TotalKoans   = $PesterTestCount
                }
                Write-MeditationPrompt @Meditation
            }
        }
    }
} # end function
function Get-Blank {
    [Alias('__', 'FILL_ME_IN')]
    param()
    $null
}
function Write-MeditationPrompt {
    [CmdletBinding(DefaultParameterSetName = 'Meditation')]
    param(
        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [ValidateNotNullOrEmpty()]
        [string]
        $DescribeName,

        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Expectation,

        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ItName,

        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [ValidateNotNullOrEmpty()]
        [string]
        $Meditation,

        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [ValidateNotNull()]
        [int]
        $KoansPassed,

        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [ValidateNotNull()]
        [int]
        $TotalKoans,

        [Parameter(Mandatory, ParameterSetName = 'Greeting')]
        [switch]
        $Greeting
    )

    $Red = @{ForegroundColor = "Red"}
    $Blue = @{ForegroundColor = "Cyan"}
    $Koan = $Script:ZenSayings | Get-Random
    $SleepTime = @{Milliseconds = 500}

    if ($PSCmdlet.ParameterSetName -eq 'Greeting') {
        Write-Host -ForegroundColor Cyan @"
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

"@
        return
    }
    Write-Host @Red @"
{Describe "$DescribeName"} has damaged your karma.
"@
    Start-Sleep @SleepTime
    Write-Host @Blue @"

    You have not yet reached enlightenment.

    The answers you seek...

"@
    Write-Host @Red @"
$Expectation
"@
    Start-Sleep @SleepTime
    Write-Host @Blue @"

    Please meditate on the following code:

"@
    Write-Host @Red @"
[It] $ItName
$Meditation
"@
    Start-Sleep @SleepTime
    Write-Host @Blue @"

    $($Koan -replace "`n","`n    ")

    Your path thus far:

"@
    $ProgressAmount = "$KoansPassed/$TotalKoans"
    [int]$ProgressWidth = $host.UI.RawUI.WindowSize.Width * 0.8 - ($ProgressAmount.Length + 4)
    $PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

    " [{0}{1}] {2}" -f @(
        "$([char]0x25a0)" * $PortionDone
        "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
        $ProgressAmount
    ) | Write-Host @Blue

    Write-Host @Blue @"

    You may run 'rake -Meditate' to begin your meditation.

"@
}
function Initialize-KoanDirectory {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium")]
    param(
        [Parameter()]
        [switch]
        $FirstImport
    )
    if ($FirstImport -or $PSCmdlet.ShouldProcess($script:KoanFolder, "Restore the koans to a blank slate")) {
        if (Test-Path -Path $script:KoanFolder) {
            Write-Verbose "Removing the entire koans folder..."
            Remove-Item -Recurse -Path $script:KoanFolder -Force
        }
        Write-Debug "Copying koans to folder"
        Copy-Item -Path "$PSScriptRoot/Koans" -Recurse -Destination $script:KoanFolder
        Write-Verbose "Koans copied to '$script:KoanFolder'"
    }
}

$script:ZenSayings = Import-CliXml -Path ($PSScriptRoot | Join-Path -ChildPath "Data/Meditations.clixml")
$script:KoanFolder = $Home | Join-Path -ChildPath 'PSKoans'

if (-not (Test-Path -Path $script:KoanFolder)) {
    Initialize-KoanDirectory -FirstImport
}