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
            exit
        }

        Write-Host -ForegroundColor Cyan @"
    Welcome, seeker of enlightenment. 
    Please wait a moment while we examine your karma...

"@
        $Red = @{ForegroundColor = "Red"}
        $Blue = @{ForegroundColor = "Cyan"}
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
        
            Write-Host @Red @"
    {Describe "$($NextKoanFailed.Describe)"} has damaged your karma.
"@
            Write-Host @Blue @"

    You have not yet reached enlightenment.
    
    The answers you seek...
"@
            Write-Host @Red @"
    $($NextKoanFailed.ErrorRecord)
"@
            Write-Host @Blue @"
    
    Please meditate on the following code:
"@
            Write-Host @Red @"
    [It] $($NextKoanFailed.Name)
    $($NextKoanFailed.StackTrace)
"@
            Write-Host @Blue @"

    Mountains are merely mountains.
        
    Your path thus far: 

"@
            $ProgressAmount = "$KoansPassed/$PesterTestCount"
            $ProgressWidth = $host.UI.RawUI.WindowSize.Width - (3 + $ProgressAmount.Length)
            $PortionDone = ($KoansPassed / $PesterTestCount) * $ProgressWidth

            "[{0}{1}] {2}" -f @(
                "$([char]0x25a0)" * $PortionDone
                "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
                $ProgressAmount
            ) | Write-Host @Blue

            Write-Host @Blue @"
    
    You may run 'rake -Meditate' to begin your meditation.

"@
        } # end if
    } # end Process
} # end function
function Get-Blank {
    [Alias('__', 'FILL_ME_IN')]
    param()
    $null
}