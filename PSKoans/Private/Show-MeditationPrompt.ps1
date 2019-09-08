using namespace System.Management.Automation

function Show-MeditationPrompt {
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
    [Alias('Write-MeditationPrompt')]
    [OutputType([void])]
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

        [Parameter(Mandatory, ParameterSetName = 'Meditation')]
        [PSObject]
        $CurrentTopic,

        [Parameter()]
        [string[]]
        $RequestedTopic,

        [Parameter()]
        [PSObject[]]
        $Results
    )
    begin {
        $Red = @{ForegroundColor = 'Red' }
        $Blue = @{ForegroundColor = 'Cyan' }
        $White = @{ForegroundColor = 'Yellow' }
        $Green = @{ForegroundColor = 'Green' }

        $Koan = (Get-Random -InputObject $script:MeditationStrings) -replace '^|\r?(\n)', ('$1    {0} ' -f [char]0x258c)
        $TopicList = ($RequestedTopic -join "`n        - ")

        # Get the first usable value for the console width
        $ConsoleWidth = ($host.UI.RawUI.WindowSize.Width, $host.UI.RawUI.BufferSize.Width, 50).Where{ $_ -ge 50 }[0]
    }
    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Greeting' {
                Write-Host @Blue $script:MeditationPrompts['Welcome']

                break
            }
            'Meditation' {
                Write-Host @Red ($script:MeditationPrompts['Describe'] -f $DescribeName)
                Write-Host @Blue $script:MeditationPrompts['TestFailed']

                Write-Host @Red $Expectation

                Write-Host @Blue $script:MeditationPrompts['Meditate']
                Write-Host @Red ($script:MeditationPrompts['Subject'] -f [char]0xd7, $ItName, $Meditation)

                Write-Host @White ($script:MeditationPrompts['Koan'] -f $Koan)

                if ($PSBoundParameters.ContainsKey('Topic')) {
                    Write-Host @Blue (
                        $script:MeditationPrompts['Topic'] -f @(
                            ($null, 's')[$RequestedTopic.Count -gt 1]
                            $TopicList
                        )
                    )
                }

                Write-Host @Blue $script:MeditationPrompts['Path']

                Write-Verbose 'Calculating progress...'
                $TopicProgressAmount = "{0}/{1}" -f $CurrentTopic.Completed, $CurrentTopic.Total
                $TotalProgressAmount = "$KoansPassed/$TotalKoans"

                [int] $ProgressWidth = $ConsoleWidth * 0.65 - ($TotalProgressAmount.Width + 12)
                [int] $TopicProgressWidth = $ProgressWidth / 2

                #region TopicProgressBar
                if ($RequestedTopic.Count -ne 1) {
                    [int] $PortionDone = ($CurrentTopic.Completed / $CurrentTopic.Total) * $TopicProgressWidth

                    $ProgressBar = " [{3}]: [{0}{1}] {2}" -f @(
                        "$([char]0x25a0)" * $PortionDone
                        "$([char]0x2015)" * ($TopicProgressWidth - $PortionDone)
                        $TopicProgressAmount
                        $CurrentTopic.Name
                    )
                    Write-Host $ProgressBar @Blue
                }
                #endregion TopicProgressBar
                Write-Host

                if ($PSBoundParameters.ContainsKey('Results')) {
                    foreach ($KoanResult in $Results) {
                        $Params = @{
                            Object = $script:MeditationPrompts['DetailEntry'] -f @(
                                if ($KoanResult.Passed) { [char]0x25b8 } else { [char]0xd7 }
                                $KoanResult.Name
                            )
                        }
                        $Params += if ($KoanResult.Passed) { $Green } else { $Red }
                        Write-Host @Params
                    }
                }

                Write-Host
                #region TotalProgressBar
                [int] $PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

                $ProgressBar = " [Total]: [{0}{1}] {2}" -f @(
                    "$([char]0x25a0)" * $PortionDone
                    "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
                    $TotalProgressAmount
                )
                Write-Host $ProgressBar @Blue

                Write-Host @Blue $script:MeditationPrompts['OpenFolder']
                #endregion TotalProgressBar

                break
            }
            'Enlightened' {
                if ($PSBoundParameters.ContainsKey('RequestedTopic')) {
                    Write-Host @Blue ($script:MeditationPrompts['CompletedTopic'] -f ($RequestedTopic -join ', '))
                }
                else {
                    Write-Host @Blue $script:MeditationPrompts['Completed']
                }

                $TotalProgressAmount = "$KoansPassed/$TotalKoans"
                [int]$ProgressWidth = $host.UI.RawUI.WindowSize.Width * 0.8 - ($TotalProgressAmount.Length + 4)
                $PortionDone = ($KoansPassed / $TotalKoans) * $ProgressWidth

                $ProgressBar = " [{0}{1}] {2}" -f @(
                    "$([char]0x25a0)" * $PortionDone
                    "$([char]0x2015)" * ($ProgressWidth - $PortionDone)
                    $TotalProgressAmount
                )
                Write-Host $ProgressBar @Blue

                if (-not $PSBoundParameters.ContainsKey('RequestedTopic')) {
                    Write-Host @Blue $script:MeditationPrompts['BookSuggestion']
                }

                break
            }
        }
    }
}
