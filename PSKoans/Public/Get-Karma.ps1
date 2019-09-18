function Get-Karma {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Get-Karma.md')]
    [OutputType([void])]
    [Alias()]
    param(
        [Alias('Koan', 'File')]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                $Values = (Get-PSKoan -IncludeModule * -Scope User -SkipAttributeParsing).Topic
                return @($Values) -like "$WordToComplete*"
            }
        )]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'IncludeModule')]
        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                $Values = Get-PSKoanLocation |
                    Join-Path -ChildPath 'Modules' |
                    Get-ChildItem -Directory |
                    Select-Object -ExpandProperty Name
                return @($Values) -like "$WordToComplete*"
            }
        )]
        [string[]]
        $IncludeModule,

        [Parameter(Mandatory, ParameterSetName = 'ModuleOnly')]
        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Switch]
        $Module,

        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Alias('ListKoans')]
        [switch]
        $ListTopics
    )
    switch ($PSCmdlet.ParameterSetName) {
        'ListKoans' {
            $params = @{
                Scope = 'User'
            }
            switch ($true) {
                { $Topic }         { $params['Topic'] = $Topic }
                { $Module }        { $params['Module'] = $Module }
                { $IncludeModule } { $params['IncludeModule'] = $IncludeModule }
            }
            Get-PSKoan @params
        }
        "Default" {
            Write-Verbose 'Sorting koans...'
            try {
                $Params = @{
                    ExcludeDefaultKoans = $ExcludeDefaultKoans
                }
                if ($Topic) {
                    Write-Verbose "Getting Koans matching selected topic(s): $($Topic -join ', ')"
                    $Params['Topic'] = $Topic
                }
                if ($Module) {
                    Write-Verbose "Getting Koans from the selected module(s): $($Module -join ', ')"
                    $Params['Module'] = $Module
                }
                $SortedKoanList = Get-Koan @Params
            }
            catch {
                $PSCmdlet.ThrowTerminatingError($_)
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

                [PSCustomObject]@{
                    PSTypeName     = 'PSKoans.Result'
                    Describe       = $NextKoanFailed.Describe
                    It             = $NextKoanFailed.Name
                    Expectation    = $NextKoanFailed.ErrorRecord
                    Meditation     = $NextKoanFailed.StackTrace
                    KoansPassed    = $KoansPassed
                    TotalKoans     = $TotalKoans
                    CurrentTopic   = [PSCustomObject]@{
                        Name      = $KoanFile.Name -replace '\.Koans\.ps1$'
                        Completed = $PesterTests.PassedCount
                        Total     = $PesterTests.TotalCount
                    }
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
