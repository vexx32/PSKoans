Write-FormatView -TypeName PSKoans.Result -Property Describe, It, Expectation, Meditation, KoansPassed, TotalKoans, CurrentTopic -AsList


Write-FormatView -TypeName PSKoans.Result -Action {
    Write-FormatViewExpression -Text @"
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...
"@ -ForegroundColor 'PSKoans.Meditation.Text'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock {
        "Describing '$($_.Describe)' has damaged your karma."
    } -ForegroundColor 'PSKoans.Meditation.Error'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -Text @"
    You have not yet reached enlightenment.

    The answers you seek...
"@ -ForegroundColor 'PSKoans.Meditation.Text'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -Property Expectation -ForegroundColor 'PSKoans.Meditation.Error'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -Text @"
    Please meditate on the following code:
"@ -ForegroundColor 'PSKoans.Meditation.Text'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock {
        @"
{0} It {1}
{2}
"@ -f [char]0xd7, $_.It, $_.Meditation
    } -ForegroundColor 'PSKoans.Meditation.Error'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock {
        & (Get-Module -Name PSKoans) {
            (Get-Random -InputObject $script:MeditationStrings) -replace '^|(\r?\n)', ('$1    {0} ' -f [char]0x258c)
        }
    } -ForegroundColor 'PSKoans.Meditation.Koan'

    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -If { $_.RequestedTopic } -ScriptBlock {
        $TopicList = ($_.RequestedTopic -join "`n        - ")
        @"

    You must meditate further on your selected topic{0}:
        - {1}

"@ -f ($null, 's')[$_.RequestedTopic.Count -gt 1], $TopicList
    } -ForegroundColor 'PSKoans.Meditation.Text'

    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -Text @"
    You examine the path beneath your feet...
"@ -ForegroundColor 'PSKoans.Meditation.Text'

    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -If { $_.RequestedTopic.Count -ne 1 } -ScriptBlock {
        $ConsoleWidth = ($host.UI.RawUI.WindowSize.Width, $host.UI.RawUI.BufferSize.Width, 80).Where{ $_ -ge 30 }[0]
        $ProgressWidth = $ConsoleWidth * 0.5
        $TopicProgressAmount = "{0}/{1}" -f $_.CurrentTopic.Completed, $_.CurrentTopic.Total

        [int] $PortionDone = ($_.CurrentTopic.Completed / $_.CurrentTopic.Total) * $ProgressWidth

        @"

 [{3}]: [{0}{1}] {2}

"@ -f @(
            "$([char]0x25a0)" * $PortionDone
            "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
            $TopicProgressAmount
            $_.CurrentTopic.Name
        )
    } -ForegroundColor 'PSKoans.Meditation.Progress'

    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -ScriptBlock {
        $ConsoleWidth = ($host.UI.RawUI.WindowSize.Width, $host.UI.RawUI.BufferSize.Width, 80).Where{ $_ -ge 30 }[0]
        $ProgressWidth = $ConsoleWidth * 0.8

        [int] $PortionDone = ($_.KoansPassed / $_.TotalKoans) * $ProgressWidth

        " [Total]: [{0}{1}] {2}" -f @(
            "$([char]0x25a0)" * $PortionDone
            "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
            $TotalProgressAmount
        )
    } -ForegroundColor 'PSKoans.Meditation.Progress'

    Write-FormatViewExpression -Newline
    Write-FormatViewExpression -Newline

    Write-FormatViewExpression -Text @"
Run 'Show-Karma -Meditate' to begin your meditations.
"@ -ForegroundColor 'PSKoans.Meditation.Text'
}


<#
[PSCustomObject]@{
    Describe       = $NextKoanFailed.Describe
    It             = $NextKoanFailed.Name
    Expectation    = $NextKoanFailed.ErrorRecord
    Meditation     = $NextKoanFailed.StackTrace
    KoansPassed    = $KoansPassed
    TotalKoans     = $TotalKoans
    CurrentTopic   = [PSCustomObject]$script:CurrentTopic
    Results        = $PesterTests.TestResult
    RequestedTopic = $Topic
}
#>
