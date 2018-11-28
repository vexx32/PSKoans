function Write-MeditationPrompt {
    <#
	.SYNOPSIS
        Provides a mechanism for Measure-Karma to write clean output.
	.DESCRIPTION
        Provides simplified and targeted output for koan test results. Only shows the next
        failing koan; all other output is suppressed.
    .NOTES
        Author: Joel Sallow
        Module: PSKoans
    .LINK
        https://github.com/vexx32/PSKoans
	#>
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
        [Parameter(Mandatory, ParameterSetName = 'Enlightened')]
        [ValidateNotNull()]
        [int]
        $KoansPassed,

        [Parameter(Mandatory, ParameterSetName = "Meditation")]
        [Parameter(Mandatory, ParameterSetName = 'Enlightened')]
        [ValidateNotNull()]
        [int]
        $TotalKoans,

        [Parameter(Mandatory, ParameterSetName = 'Greeting')]
        [switch]
        $Greeting,

        [Parameter(Mandatory, ParameterSetName = 'Enlightened')]
        [switch]
        $Complete,

        [Parameter()]
        [string[]]
        $Topic
    )

    $Red = @{ForegroundColor = "Red"}
    $Blue = @{ForegroundColor = "Cyan"}
    $Koan = $script:Meditations | Get-Random
    $SleepTime = @{Milliseconds = 50}

    #region Prompt Text
    $Prompts = @{
        Welcome        = @"
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

"@
        Describe       = @"
Describing '$DescribeName' has damaged your karma.
"@
        TestFailed     = @"

    You have not yet reached enlightenment.

    The answers you seek...

"@
        Expectation    = $Expectation
        Meditate       = @"

    Please meditate on the following code:

"@
        Subject        = @"
[It] $ItName
$Meditation
"@
        Wisdom         = @"

    $($Koan -replace "`n","`n    ")

    Your path thus far:

"@
        WisdomTopic    = @"

    $($Koan -replace "`n","`n    ")

    Your path thus far in topics $($Topic -join ', '):

"@
        OpenFolder     = @"

You may run 'Measure-Karma -Meditate' to begin your meditation.

"@
        Completed      = @"
    Congratulations! You have taken the first steps towards enlightenment.

    You cast your gaze back upon the path that you have walked:

"@
        CompletedTopic = @"
    Congratulations! You have taken the first steps towards enlightenment.

    You have completed: $($Topic -join ', ')

    You cast your gaze back upon the path that you have walked:

"@
        BookSuggestion = @"

    If you would like to further your studies in this manner, consider investing in
    'PowerShell by Mistake' by Don Jones - https://leanpub.com/powershell-by-mistake
"@
    }
    #endregion Prompt Text

    switch ($PSCmdlet.ParameterSetName) {
        'Greeting' {
            Write-Host -ForegroundColor Cyan $Prompts['Welcome']
            break
        }
        'Meditation' {
            Write-Host @Red $Prompts['Describe']
            Start-Sleep @SleepTime
            Write-Host @Blue $Prompts['TestFailed']
            Write-Host @Red $Prompts['Expectation']
            Start-Sleep @SleepTime
            Write-Host @Blue $Prompts['Meditate']
            Write-Host @Red $Prompts['Subject']
            Start-Sleep @SleepTime

            if ($PSBoundParameters.ContainsKey('Topic')) {
                Write-Host @Blue $Prompts['WisdomTopic']
            }
            else {
                Write-Host @Blue $Prompts['Wisdom']
            }

            Write-Verbose 'Calculating progress...'
            $ProgressAmount = "$KoansPassed/$TotalKoans"
            [int]$ProgressWidth = $host.UI.RawUI.WindowSize.Width * 0.8 - ($ProgressAmount.Length + 4)
            $PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

            " [{0}{1}] {2}" -f @(
                "$([char]0x25a0)" * $PortionDone
                "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
                $ProgressAmount
            ) | Write-Host @Blue

            Write-Host @Blue $Prompts['OpenFolder']
            break
        }
        'Enlightened' {
            if ($PSBoundParameters.ContainsKey('Topic')) {
                Write-Host @Blue $Prompts['CompletedTopic']
            }
            else {
                Write-Host @Blue $Prompts['Completed']
            }

            $ProgressAmount = "$KoansPassed/$TotalKoans"
            [int]$ProgressWidth = $host.UI.RawUI.WindowSize.Width * 0.8 - ($ProgressAmount.Length + 4)
            $PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

            " [{0}{1}] {2}" -f @(
                "$([char]0x25a0)" * $PortionDone
                "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
                $ProgressAmount
            ) | Write-Host @Blue

            if (-not $PSBoundParameters.ContainsKey('Topic')) {
                Write-Host @Blue $Prompts['BookSuggestion']
            }

            break
        }
    }
}