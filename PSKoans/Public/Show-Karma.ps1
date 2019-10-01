function Show-Karma {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Show-Karma.md')]
    [OutputType([void])]
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate', 'Clear-Path', 'Measure-Karma')]
    param(
        [Parameter(ParameterSetName = 'ListKoans')]
        [Parameter(ParameterSetName = 'ModuleOnly')]
        [Parameter(ParameterSetName = 'IncludeModule')]
        [Parameter(ParameterSetName = 'Default')]
        [Alias('Koan', 'File')]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'ModuleOnly')]
        [Parameter(ParameterSetName = 'ListKoans')]
        [SupportsWildcards()]
        [string[]]
        $Module,

        [Parameter(Mandatory, ParameterSetName = 'IncludeModule')]
        [SupportsWildcards()]
        [string[]]
        $IncludeModule,

        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Alias('ListKoans', 'ListTopics')]
        [switch]
        $List,

        [Parameter(Mandatory, ParameterSetName = 'OpenFolder')]
        [Alias('Meditate')]
        [switch]
        $Contemplate,

        [Parameter()]
        [Alias()]
        [switch]
        $ClearScreen,

        [Parameter(ParameterSetName = 'ModuleOnly')]
        [Parameter(ParameterSetName = 'IncludeModule')]
        [Parameter(ParameterSetName = 'Default')]
        [Alias()]
        [switch]
        $Detailed
    )

    $GetParams = @{}
    switch ($pscmdlet.ParameterSetName) {
        'IncludeModule' { $GetParams['IncludeModule'] = $IncludeModule }
        'ModuleOnly'    { $GetParams['Module'] = $Module }
        { $Topic }      { $GetParams['Topic'] = $Topic }
    }

    switch ($PSCmdlet.ParameterSetName) {
        'ListKoans' {
            Get-PSKoan @GetParams
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
        default {
            if ($ClearScreen) {
                Clear-Host
            }

            Show-MeditationPrompt -Greeting
            $Results = Get-Karma @GetParams

            if ($Results.Complete) {
                $Params = @{
                    KoansPassed    = $Results.KoansPassed
                    TotalKoans     = $Results.TotalKoans
                    RequestedTopic = $Topic
                    Complete       = $Results.Complete
                }
            }
            else {
                $Params = @{
                    DescribeName   = $Results.Describe
                    ItName         = $Results.It
                    Expectation    = $Results.Expectation
                    Meditation     = $Results.Meditation
                    KoansPassed    = $Results.KoansPassed
                    TotalKoans     = $Results.TotalKoans
                    CurrentTopic   = $Results.CurrentTopic
                    RequestedTopic = $Topic
                }

                if ($Detailed) {
                    $Params.Add('Results', $Results.Results)
                }
            }

            Show-MeditationPrompt @Params
        }
    }
}
