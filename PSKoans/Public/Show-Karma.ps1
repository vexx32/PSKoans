function Show-Karma {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Show-Karma.md')]
    [OutputType([void])]
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate', 'Clear-Path', 'Measure-Karma')]
    param(
        [Parameter(ParameterSetName = 'Default')]
        [Alias('Koan', 'File')]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                $Values = (Get-PSKoanFile).Topic
                return @($Values) -like "$WordToComplete*"
            }
        )]
        [SupportsWildcards()]
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

        [Parameter()]
        [Alias()]
        [switch]
        $ClearScreen,

        [Parameter(ParameterSetName = 'Default')]
        [Alias()]
        [switch]
        $Detailed
    )
    switch ($PSCmdlet.ParameterSetName) {
        'ListKoans' {
            Get-PSKoanFile
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

            $Results = if ($Topic) { Get-Karma -Topic $Topic } else { Get-Karma }

            $Params = @{
                DescribeName   = $Results.Describe
                ItName         = $Results.It
                Expectation    = $Results.Expectation
                Meditation     = $Results.Meditation
                KoansPassed    = $Results.KoansPassed
                TotalKoans     = $Results.TotalKoans
                CurrentTopic   = $Results.CurrentTopic
                Results        = $PesterTests.TestResult
                RequestedTopic = $Topic
            }
            if (-not $Detailed) {
                $Params.Remove('Results')
            }

            Show-MeditationPrompt @Params
        }
    }
}
