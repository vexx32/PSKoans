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
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate','Clear-Path')]
    param(
        [Parameter(Mandatory, ParameterSetName = "OpenFolder")]
        [Alias('Koans', 'Meditate')]
        [switch]
        $Contemplate,

        [Parameter(Mandatory, ParameterSetName = "Reset")]
        [switch]
        $Reset
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

            if ($TotalKoans -eq 0) {
                # Something's wrong; possibly a koan folder from older versions, or a folder exists but has no files
                Write-Warning 'No koans found in your koan directory. Initiating full reset...'
                Initialize-KoanDirectory
                Measure-Karma @PSBoundParameters # Re-call ourselves with the same parameters

                return # skip the rest of the function
            }

            $KoansPassed = 0

            foreach ($KoanFile in $SortedKoanList.Path) {
                Write-Verbose "Testing karma with file [$KoanFile]"

                $GlobalScope = [PSModuleInfo]::new($true)
                $PesterParams = @{
                    Script   = $KoanFile
                    PassThru = $true
                    Show     = 'None'
                }

                # Execute in a fresh scope to prevent internal secrets being leaked
                & $GlobalScope {
                    param($Command, $Params)
                    # Command must be passed in as a parameter to ensure it is read correctly
                    & $Command @Params
                } @((Get-Command Invoke-Koan), $PesterParams)

                $KoansPassed += $PesterTests.PassedCount

                Write-Verbose "Karma: $KoansPassed"
                if ($PesterTests.FailedCount -gt 0) {
                    Write-Verbose "Your karma has been damaged."
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