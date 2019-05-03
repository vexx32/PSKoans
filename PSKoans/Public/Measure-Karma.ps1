﻿function Measure-Karma {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Default",
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Measure-Karma.md')]
    [OutputType([void])]
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate', 'Clear-Path')]
    param(
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Reset')]
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
        $Reset,

        [Parameter()]
        [Alias()]
        [switch]
        $ClearScreen
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
            if ($Topic) {
                Write-Verbose "Resetting lessons: $($Topic -join ', ')"
                Initialize-KoanDirectory -Topic $Topic
            }
            else {
                Write-Verbose "Reinitializing koan directory"
                Initialize-KoanDirectory
            }
        }
        'OpenFolder' {
            Write-Verbose "Opening koans folder"
            if ( $env:PSKoans_EditorPreference -eq 'code-insiders' -and (Get-Command -Name 'code-insiders' -ErrorAction SilentlyContinue) ) {
                $VSCodeSplat = @{
                    FilePath     = 'code-insiders'
                    ArgumentList = '"{0}"' -f (Get-PSKoanLocation)
                    NoNewWindow  = $true
                }
                Start-Process @VSCodeSplat
            }
            elseif (Get-Command -Name 'code' -ErrorAction SilentlyContinue) {
                $VSCodeSplat = @{
                    FilePath     = 'code'
                    ArgumentList = '"{0}"' -f (Get-PSKoanLocation)
                    NoNewWindow  = $true
                }
                Start-Process @VSCodeSplat
            }
            else {
                Get-PSKoanLocation | Invoke-Item
            }
        }
        "Default" {
            if ($ClearScreen) {
                Clear-Host
            }

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
            }
            else {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = $KoansPassed
                    TotalKoans  = $PesterTests.TotalCount
                }
            }

            if ($PSBoundParameters.ContainsKey('Topic')) {
                $Meditation.Add('RequestedTopic', $Topic)
            }

            Show-MeditationPrompt @Meditation
        }
    }
}
