function Measure-Karma {
    <#
	.SYNOPSIS
        Reflect on your progress and check your answers.
    .DESCRIPTION
        Measure-Karma executes Pester against the koans to evaluate if you have made the necessary
        corrections for success.
    .PARAMETER Topic
        Execute koans only from the selected Topic(s). Regex patterns are permitted.
    .PARAMETER ListTopics
        Output a complete list of available koan topics.
    .PARAMETER Contemplate
        Opens your local koan folder. If you'd like PSKoans to use VS Code Insiders, set $env:PSKoans_EditorPreference
	    equal to "code-insiders".
	.PARAMETER Reset
        Resets everything in your local koan folder to a blank slate. Use with caution.
    .EXAMPLE
        Measure-Karma

        Assesses the results of the Pester tests, and builds the meditation prompt.
    .EXAMPLE
        meditate -Contemplate

        Opens the user's koans folder, housed in '$home\PSKoans'. If VS Code is in $env:Path,
        opens in VS Code.
    .EXAMPLE
        Measure-Karma -Reset

        Prompts for confirmation, before wiping out the user's koans folder and restoring it back
        to its initial state.
    .LINK
        https://github.com/vexx32/PSKoans
	.NOTES
        Author: Joel Sallow
        Module: PSKoans
	#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default")]
    [OutputType([void])]
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate', 'Clear-Path')]
    param(
        [Parameter(ParameterSetName = 'Default')]
        [Alias('Koan', 'File')]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                $Values = Get-PSKoanLocation | Get-ChildItem -Recurse -Filter '*.Koans.ps1' |
                    Sort-Object -Property BaseName |
                    ForEach-Object {
                    $_.BaseName -replace '\.Koans$'
                }

                return @($Values) -like "$WordToComplete*"
            }
        )]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Alias('ListKoans')]
        [switch]
        $ListTopics,

        [Parameter(Mandatory, ParameterSetName = "OpenFolder")]
        [Alias('Meditate')]
        [switch]
        $Contemplate,

        [Parameter(Mandatory, ParameterSetName = "Reset")]
        [switch]
        $Reset
    )
    switch ($PSCmdlet.ParameterSetName) {
        'ListKoans' {
            Get-PSKoanLocation |
                Get-ChildItem -Recurse -File -Filter '*.Koans.ps1' |
                ForEach-Object {
                $_.BaseName -replace '\.Koans$'
            }
        }
        'Reset' {
            Write-Verbose "Reinitializing koan directory"
            Initialize-KoanDirectory
        }
        'OpenFolder' {
            Write-Verbose "Opening koans folder"
            if ( $env:PSKoans_EditorPreference -eq 'code-insiders' -and (Get-Command -Name 'code-insiders' -ErrorAction SilentlyContinue) ) {
                Start-Process -FilePath 'code-insiders' -ArgumentList "`"$(Get-PSKoanLocation)`"" -NoNewWindow
            }
            elseif (Get-Command -Name 'code' -ErrorAction SilentlyContinue) {
                Start-Process -FilePath 'code' -ArgumentList "`"$(Get-PSKoanLocation)`"" -NoNewWindow
            }
            else {
                Get-PSKoanLocation | Invoke-Item
            }
        }
        "Default" {
            Clear-Host

            Show-MeditationPrompt -Greeting

            Write-Verbose 'Sorting koans...'
            if ($Topic) {
                Write-Verbose "Getting Koans matching selected topic(s): $($Topic -join ', ')"
                $SortedKoanList = Get-Koan -Topic $Topic
            }
            else {
                $SortedKoanList = Get-Koan
            }

            Write-Verbose "Koan files retrieved: $($SortedKoanList.Count)"
            Write-Verbose 'Counting koans...'
            [int]$TotalKoans = $SortedKoanList | Measure-Koan

            if ($TotalKoans -eq 0) {
                if ($Topic) {
                    $ErrorDetails = @{
                        ExceptionType    = 'System.IO.FileNotFoundException'
                        ExceptionMessage = 'Could not find any koans that match the specified Topic(s)'
                        ErrorId          = 'PSKoans.NoMatchingKoansFound'
                        ErrorCategory    = 'ObjectNotFound'
                        TargetObject     = $Topic -join ','
                    }
                    $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
                }

                # Something's wrong; possibly a koan folder from older versions, or a folder exists but has no files
                Write-Warning 'No koans found in your koan directory. Initiating full reset...'
                Initialize-KoanDirectory
                Measure-Karma @PSBoundParameters # Re-call ourselves with the same parameters

                return # Skip the rest of the function
            }

            $KoansPassed = 0

            foreach ($KoanFile in $SortedKoanList) {
                Write-Verbose "Testing karma with file [$($KoanFile.Path)]"

                # Execute in a fresh scope to prevent internal secrets being leaked
                $PesterTests = Invoke-Koan @{
                    Script   = $KoanFile.Path
                    PassThru = $true
                    Show     = 'None'
                }

                $KoansPassed += $PesterTests.PassedCount

                Write-Verbose "Karma: $KoansPassed"
                if ($PesterTests.FailedCount -gt 0) {
                    Write-Verbose 'Your karma has been damaged.'
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
                    CurrentTopic = @{
                        Name      = $KoanFile.Name -replace '\.Koans\.ps1$'
                        Completed = $PesterTests.PassedCount
                        Total     = $PesterTests.TotalCount
                    }
                }

                if ($PSBoundParameters.ContainsKey('Topic')) {
                    $Meditation.Add('RequestedTopic', $Topic)
                }
            }
            else {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = $KoansPassed
                    TotalKoans  = $PesterTestCount
                }

                if ($PSBoundParameters.ContainsKey('Topic')) {
                    $Meditation.Add('RequestedTopic', $Topic)
                }
            }

            Show-MeditationPrompt @Meditation
        }
    }
}
