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
        $Help
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
                ForEach-Object {
                    $_Koan = $_
                    $_.ScriptBlock.Attributes |
                        Where-Object { $_.TypeID -Match 'KoanAttribute' } |
                        ForEach-Object {
                            $_.FilePath = $_Koan.Path;
                            $_.FileCmdlet = $_Koan;
                            $_
                        }
                    } | 
                Sort-Object Position
            
            Write-Verbose 'Counting koans...'
            $TotalKoans = $SortedKoanList.FileCmdlet | Measure-Koan
            
            if ($TotalKoans -eq 0) {
                # Something's wrong; possibly a koan folder from older versions, or a folder exists but has no files
                Write-Warning 'No koans found in your koan directory. Initiating full reset...'
                Initialize-KoanDirectory
                Measure-Karma @PSBoundParameters # Re-call ourselves with the same parameters

                continue # skip the rest of the function
            }
            
            $KoansPassed = 0

            foreach ($Koan in $SortedKoanList) {
                $PesterParams = @{
                    PassThru = $true
                    Show     = 'None'
                }
                $PesterTests = $Koan.InvokePester($PesterParams)
                $KoansPassed += $PesterTests.PassedCount
                
                Write-Verbose "Karma: $KoansPassed"
                if ($Koan.GetFailedCount() -gt 0) {
                    Write-Verbose "Your karma has been damaged."
                    break
                }
            }

            $KoanFailed = $SortedKoanList.GetTestResults('Failed') | select -First 1
            if ($KoanFailed) {
                $Meditation = @{
                    DescribeName = $KoanFailed.Describe
                    Expectation  = $KoanFailed.ErrorRecord
                    ItName       = $KoanFailed.Name
                    Meditation   = $KoanFailed.StackTrace
                    KoansPassed  = $KoansPassed
                    TotalKoans   = $TotalKoans
                }
                Write-MeditationPrompt @Meditation

                #Invoke Koan Help Data.
                $SortedKoanList | Where-Object { $_.GetFailedCount() -gt 0 } | Select-Object -First 1 | ForEach-Object InvokeHelpInfo
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