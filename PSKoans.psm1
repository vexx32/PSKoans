function Invoke-PSKoans {
    [CmdletBinding()]
    [Alias('Rake')]
    param(
        [switch]
        $NoClear,

        [switch]
        $Meditate
    )
    begin {
        if (!$NoClear) {
            Clear-Host
        }
        if ($Meditate) {
            Invoke-Item "$PSScriptRoot\Koans"
            return
        }

        Write-MeditationPrompt -Greeting

        $PesterTestCount = Invoke-Pester -PassThru -Show None | Select-Object -ExpandProperty TotalCount
        $Tests = Get-ChildItem -Path "$PSScriptRoot\Koans" -Filter '*.Tests.ps1' -Recurse
        $KoansPassed = 0
    }
    process {
        foreach ($KoanFile in $Tests) {
            $PesterTests = Invoke-Pester -PassThru -Show None -Script $KoanFile.FullName
            $KoansPassed += $PesterTests.PassedCount

            if ($PesterTests.FailedCount -gt 0) {
                break
            } # end if
        } # end foreach

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
    Write-Host @Blue @"

    You have not yet reached enlightenment.
    
    The answers you seek...
"@
    Write-Host @Red $Expectation
    Write-Host @Blue @"
    
    Please meditate on the following code:
"@
    Write-Host @Red @"
    [It] $ItName
    $Meditation
"@
    Write-Host @Blue @"

    Mountains are merely mountains.
        
    Your path thus far: 

"@
    $ProgressAmount = "$KoansPassed/$TotalKoans"
    $ProgressWidth = $host.UI.RawUI.WindowSize.Width - (3 + $ProgressAmount.Length)
    $PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

    "[{0}{1}] {2}" -f @(
        "$([char]0x25a0)" * $PortionDone
        "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
        $ProgressAmount
    ) | Write-Host @Blue

    Write-Host @Blue @"
    
    You may run 'rake -Meditate' to begin your meditation.

"@
}