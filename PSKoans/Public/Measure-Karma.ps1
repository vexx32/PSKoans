function Measure-Karma {
    <#
	.SYNOPSIS
        Reflect on your progress and check your answers.
    .DESCRIPTION
        Get-Enlightenment executes Pester against the koans to evaluate if you have made the necessary
        corrections for success.
    .PARAMETER Contemplate
        Opens your local koan folder.
	.PARAMETER Reset
        Resets everything in your local koan folder to a blank slate. Use with caution.
    .EXAMPLE
        PS> Measure-Karma

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> rake

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        PS> meditate -Contemplate

        Opens the user's koans folder, housed in '$home\PSKoans'. If VS Code is in $env:Path,
        opens in VS Code.
    .EXAMPLE
        PS> Measure-Karma -Reset

        Prompts for confirmation, before wiping out the user's koans folder and restoring it back
        to its initial state.
    .LINK
        https://github.com/vexx32/PSKoans
	.NOTES
        Author: Joel Sallow
        Module: PSKoans
	#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default")]
    [Alias('Rake', 'Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate','Clear-Path')]
    param(
        [Parameter(Mandatory, ParameterSetName = "OpenFolder")]
        [Alias('Koans', 'Meditate')]
        [switch]
        $Contemplate,

        [Parameter(Mandatory, ParameterSetName = "Reset")]
        [switch]
        $Reset,

        #Help is not listed since it attaches to Karma Default actions
        [Parameter()]
        [Alias('Dojo', 'Spar')]
        [switch]
        $ShowHelp
    )
    switch ($PSCmdlet.ParameterSetName) {
        "Reset" {
            Write-Verbose "Reinitializing koan directory"
            Initialize-KoanDirectory
        }
        "OpenFolder" {
            Write-Verbose "Opening koans folder"
            if (Get-Command -Name 'Code' -ErrorAction SilentlyContinue) {
                Start-Process -FilePath 'code' -ArgumentList $env:PSKoans_Folder -NoNewWindow
            }
            else {
                Invoke-Item $env:PSKoans_Folder
            }
        }
        "Default" {
            Clear-Host

            Write-MeditationPrompt -Greeting

            Write-Verbose 'Sorting koans...'

            $SortedKoanList = Get-ChildItem "$env:PSKoans_Folder" -Recurse -Filter '*.Koans.ps1' |
                Get-Command {$_.FullName} |
                Where-Object {$_.ScriptBlock.Attributes.TypeID -match 'KoanAttribute'} |
                Sort-Object {
                $_.ScriptBlock.Attributes.Where( {$_.TypeID -match 'KoanAttribute'}).Position
            }

            Write-Verbose 'Counting koans...'
            $TotalKoans = $SortedKoanList | Measure-Koan

            $KoansPassed = 0
            foreach ($KoanFile in $SortedKoanList.Path) {

                Write-Verbose "Testing karma with file [$KoanFile]"

                $PesterParams = @{
                    Script   = $KoanFile
                    PassThru = $true
                    Show     = 'None'
                }
                $PesterTests = Invoke-Pester @PesterParams
                $KoansPassed += $PesterTests.PassedCount

                Write-Verbose "Karma: $KoansPassed"
                if ($PesterTests.FailedCount -gt 0) {
                    Write-Verbose "Your karma has been damaged."
                    if ($ShowHelp) {
                        $KoanAttribute = (Get-Command $KoanFile).ScriptBlock.Attributes | Where-Object TypeID -match 'KoanAttribute'
                        #Write-Host ($KoanAttribute | Out-String)

                        if ($KoanAttribute.HelpAction) {
                            Invoke-Command $KoanAttribute.HelpAction
                        } 
                        elseif ($KoanAttribute.HelpPath) {
                            Write-Host "Confusion is only the beginning"
                            Write-Host "Snatch the coin from my hand"
                            Write-Host ("Learn you must about {0}" -f $KoanAttribute.HelpPath)
                        }
                        elseif ($KoanAttribute.HelpURL) {
                            Write-Host "Vexx32 I am certain you will fix this block of nasty"
                            Write-Host "Confusion is only the beginning"
                            Write-Host "Your defeat has only made you stronger."
                            Write-Host $KoanAttribute.HelpURL
                        }
                    }

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
                    TotalKoans   = $TotalKoans
                }
                Write-MeditationPrompt @Meditation
            }
            else {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = $KoansPassed
                    TotalKoans  = $PesterTestCount
                }
                Write-MeditationPrompt @Meditation
            }
        }
    }
}