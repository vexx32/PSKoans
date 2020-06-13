function Get-Karma {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/main/docs/Get-Karma.md')]
    [OutputType([void])]
    [Alias()]
    param(
        [Alias('Koan', 'File')]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'ModuleOnly')]
        [Parameter(ParameterSetName = 'ListKoans')]
        [string[]]
        $Module,

        [Parameter(Mandatory, ParameterSetName = 'IncludeModule')]
        [string[]]
        $IncludeModule,

        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Alias('ListKoans', 'ListTopics')]
        [switch]
        $List
    )

    $GetParams = @{
        Scope = 'User'
    }
    switch ($pscmdlet.ParameterSetName) {
        'IncludeModule' { $GetParams['IncludeModule'] = $IncludeModule }
        'ModuleOnly' { $GetParams['Module'] = $Module }
        { $Topic } { $GetParams['Topic'] = $Topic }
    }

    switch ($PSCmdlet.ParameterSetName) {
        'ListKoans' {
            Get-PSKoan @GetParams
        }
        "Default" {
            Write-Verbose 'Sorting koans...'
            try {
                $SortedKoanList = Get-PSKoan @GetParams
            }
            catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }

            Write-Verbose "Koan files retrieved: $($SortedKoanList.Count)"
            Write-Verbose 'Counting koans...'
            [int]$TotalKoans = $SortedKoanList | Measure-Koan

            if ($TotalKoans -eq 0) {
                if ($Topic) {
                    $Message = @(
                        'Could not find any PSKoans topics matching Topic(s): {0}.'
                        'Use Update-PSKoan to ensure your koan library is up to date.'
                    ) -join ' '
                    $TopicList = $Topic -join ','

                    $ErrorDetails = @{
                        ExceptionType    = 'System.IO.FileNotFoundException'
                        ExceptionMessage = $Message -f $TopicList
                        ErrorId          = 'PSKoans.TopicNotFound'
                        ErrorCategory    = 'ObjectNotFound'
                        TargetObject     = $TopicList
                    }
                    $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
                }

                # Something's wrong; possibly a koan folder from older versions, or a folder exists but has no files
                Write-Warning 'No koans found in your koan directory. Initiating full reset...'
                Update-PSKoan -Confirm:$false
                Get-Karma @PSBoundParameters # Re-call ourselves with the same parameters

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

            $Meditation = if ($PesterTests.FailedCount -gt 0) {
                $NextKoanFailed = $PesterTests.TestResult |
                    Where-Object Result -eq 'Failed' |
                    Select-Object -First 1

                $script:CurrentTopic = @{
                    Name        = $KoanFile.Topic
                    Completed   = $PesterTests.PassedCount
                    Total       = $PesterTests.TotalCount
                    CurrentLine = ($NextKoanFailed.StackTrace -split '\r?\n')[1] -replace ':.+'
                }

                [PSCustomObject]@{
                    PSTypeName     = 'PSKoans.Result'
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
            }
            else {
                [PSCustomObject]@{
                    PSTypeName     = 'PSKoans.CompleteResult'
                    KoansPassed    = $KoansPassed
                    TotalKoans     = $TotalKoans
                    RequestedTopic = $Topic
                    Complete       = $true
                }
            }

            $Meditation
        }
    }
}
