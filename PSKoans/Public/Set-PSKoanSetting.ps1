function Set-PSKoanSetting {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium', DefaultParameterSetName = 'Single',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Set-PSKoanSetting.md')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Single')]
        [string]
        $Name,

        [Parameter(Position = 1, Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Single')]
        [object]
        $Value,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = 'Multiple')]
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
                        Select-Object -Property * -ExcludeProperty $Settings.Keys.ForEach{ $_ } |
                        Select-Object -Property $Properties |
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

        $SettingsToExport = $script:DefaultSettings.Clone()

        switch ($PSCmdlet.ParameterSetName) {
            'Single' {
                $SettingsToExport[$Name] = $Value

                [PSCustomObject]$SettingsToExport |
                    ConvertTo-Json |
                    Set-Content -Path $script:ConfigPath
            }
            'Multiple' {
                $Settings.Keys.ForEach{
                    $SettingsToExport[$_] = $Settings[$_]
                }
                [PSCustomObject]$SettingsToExport |
                    ConvertTo-Json |
                    Set-Content -Path $script:ConfigPath
            }
        }
    }
}
