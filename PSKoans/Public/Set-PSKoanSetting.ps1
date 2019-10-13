function Set-PSKoanSetting {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium', DefaultParameterSetName = 'Single',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Set-PSKoanSetting.md')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Single')]
        [ArgumentCompleter(
            {
                $script:DefaultSettings.Keys.ForEach{
                    [System.Management.Automation.CompletionResult]::new(
                        $_, <# completionText #>
                        $_, <# listItemText #>
                        'ParameterValue', <# completionResultType #>
                        $_ <# toolTip #>
                    )
                }
            }
        )]
        [string]
        $Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Single')]
        [object]
        $Value,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Multiple')]
        [hashtable]
        $Settings
    )
    if (Test-Path $script:ConfigPath) {
        switch ($PSCmdlet.ParameterSetName) {
            'Single' {
                if ($Name -eq 'Location') {
                    $Value = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Value)
                }

                (Get-Content -Path $script:ConfigPath) |
                    ConvertFrom-Json |
                    Select-Object -Property *, @{ Name = $Name; Expression = { $Value } } -ExcludeProperty $Name |
                    ConvertTo-Json |
                    Set-Content -Path $script:ConfigPath
            }
            'Multiple' {
                if (Test-Path $script:ConfigPath) {
                    $Properties = @(
                        '*'
                        foreach ($key in $Settings.Keys) {
                            @{
                                Name       = $key
                                Expression = {
                                    if ($Key -eq 'Location') {
                                        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Settings[$key])
                                    }
                                    else {
                                        $Settings[$key]
                                    }
                                }
                            }
                        }
                    )
                    (Get-Content -Path $script:ConfigPath) |
                        ConvertFrom-Json |
                        Select-Object -Property $Properties -ExcludeProperty $Settings.Keys |
                        ConvertTo-Json |
                        Set-Content -Path $script:ConfigPath
                }
            }
        }
    }
    else {
        $ConfigRoot = $script:ConfigPath | Split-Path -Parent
        if (-not (Test-Path $ConfigRoot)) {
            New-Item -ItemType Directory -Path $ConfigRoot > $null
        }

        switch ($PSCmdlet.ParameterSetName) {
            'Single' {
                [PSCustomObject]@{ $Name = $Value } |
                    ConvertTo-Json |
                    Set-Content -Path $script:ConfigPath
            }
            'Multiple' {
                [PSCustomObject]$Settings |
                    ConvertTo-Json |
                    Set-Content -Path $script:ConfigPath
            }
        }
    }
}
