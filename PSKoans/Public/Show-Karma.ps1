function Show-Karma {
    [CmdletBinding(DefaultParameterSetName = 'Default',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/main/docs/Show-Karma.md')]
    [OutputType([void])]
    [Alias('Invoke-PSKoans', 'Test-Koans', 'Get-Enlightenment', 'Meditate', 'Clear-Path', 'Measure-Karma')]
    param(
        [Parameter(ParameterSetName = 'ListKoans')]
        [Parameter(ParameterSetName = 'ListKoans-ModuleOnly')]
        [Parameter(ParameterSetName = 'ListKoans-IncludeModule')]
        [Parameter(ParameterSetName = 'ModuleOnly')]
        [Parameter(ParameterSetName = 'IncludeModule')]
        [Parameter(ParameterSetName = 'OpenFile')]
        [Parameter(ParameterSetName = 'OpenFile-ModuleOnly')]
        [Parameter(ParameterSetName = 'OpenFile-IncludeModule')]
        [Parameter(ParameterSetName = 'Default')]
        [Alias('Koan', 'File')]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'ModuleOnly')]
        [Parameter(Mandatory, ParameterSetName = 'ListKoans-ModuleOnly')]
        [Parameter(Mandatory, ParameterSetName = 'OpenFile-ModuleOnly')]
        [SupportsWildcards()]
        [string[]]
        $Module,

        [Parameter(Mandatory, ParameterSetName = 'IncludeModule')]
        [Parameter(Mandatory, ParameterSetName = 'ListKoans-IncludeModule')]
        [Parameter(Mandatory, ParameterSetName = 'OpenFile-IncludeModule')]
        [Alias('Meditate')]
        [SupportsWildcards()]
        [string[]]
        $IncludeModule,

        [Parameter(Mandatory, ParameterSetName = 'ListKoans')]
        [Parameter(Mandatory, ParameterSetName = 'ListKoans-ModuleOnly')]
        [Parameter(Mandatory, ParameterSetName = 'ListKoans-IncludeModule')]
        [Alias('ListKoans', 'ListTopics')]
        [switch]
        $List,

        [Parameter(Mandatory, ParameterSetName = 'OpenFile')]
        [Parameter(Mandatory, ParameterSetName = 'OpenFile-ModuleOnly')]
        [Parameter(Mandatory, ParameterSetName = 'OpenFile-IncludeModule')]
        [Alias('Meditate')]
        [switch]
        $Contemplate,

        [Parameter(Mandatory, ParameterSetName = 'OpenFolder')]
        [Alias('OpenFolder')]
        [switch]
        $Library,

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

    $GetParams = @{ }
    switch ($PSCmdlet.ParameterSetName) {
        'IncludeModule' { $GetParams['IncludeModule'] = $IncludeModule }
        'ModuleOnly' { $GetParams['Module'] = $Module }
        { $PSBoundParameters.ContainsKey('Topic') } { $GetParams['Topic'] = $Topic }
    }

    switch ($PSCmdlet.ParameterSetName) {
        { $_ -match '^ListKoans' } {
            Get-PSKoan @GetParams
        }
        'OpenFolder' {
            $KoanLocation = Get-PSKoanLocation
            Write-Verbose "Checking existence of koans folder"
            if (-not (Test-Path $KoanLocation)) {
                Write-Verbose "Koans folder does not exist. Initiating full reset..."
                Update-PSKoan -Confirm:$false
            }

            Write-Verbose "Opening koans folder"
            $Editor = Get-PSKoanSetting -Name Editor
            if ($Editor -and (Get-Command -Name $Editor -ErrorAction SilentlyContinue)) {
                $EditorSplat = @{
                    FilePath     = $Editor
                    ArgumentList = '"{0}"' -f (Resolve-Path $KoanLocation)
                    NoNewWindow  = $true
                }
                Start-Process @EditorSplat
            }
            else {
                $KoanLocation | Invoke-Item
            }
        }
        {$_ -match '^OpenFile'} {
            # If there is no cached data, we need to call Get-Karma to populate it
            if (-not $script:CurrentTopic -or ($Topic -and $script:CurrentTopic.Name -notlike $Topic)) {
                try {
                    # We can discard this; the results we need are saved in $script:CurrentTopic
                    $null = Get-Karma @GetParams
                }
                catch {
                    $PSCmdlet.ThrowTerminatingError($_)
                }
            }

            $Editor = Get-PSKoanSetting -Name Editor
            $FilePath = (Get-PSKoan -Topic $script:CurrentTopic.Name -Scope User).Path
            $LineNumber = $script:CurrentTopic.CurrentLine

            $Arguments = switch ($Editor) {
                { $_ -in 'code', 'code-insiders' } {
                    '--goto'
                    '"{0}":{1}' -f (Resolve-Path $FilePath), $LineNumber
                    '--reuse-window'
                }
                atom {
                    '"{0}":{1}' -f (Resolve-Path $FilePath), $LineNumber
                }
                default {
                    '"{0}"' -f (Resolve-Path $FilePath)
                }
            }

            if ($Editor -and (Get-Command -Name $Editor -ErrorAction SilentlyContinue)) {
                Start-Process -FilePath $Editor -ArgumentList $Arguments -NoNewWindow
            }
            else {
                Invoke-Item -Path $FilePath
            }

            # Discard the results so we avoid accidentally returning the same result multiple times
            $script:CurrentTopic = $null
        }

        default {
            if ($ClearScreen) {
                Clear-Host
            }

            $FormatParams = @{ }
            if ($Detailed) {
                $FormatParams['View'] = 'Detailed'
            }

            try {
                Get-Karma @GetParams |
                    Format-Custom @FormatParams |
                    Out-Host
            }
            catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }
        }
    }
}
