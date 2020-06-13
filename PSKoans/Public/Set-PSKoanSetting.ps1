function Set-PSKoanSetting {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium', DefaultParameterSetName = 'Single',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/main/docs/Set-PSKoanSetting.md')]
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
        $Settings,

        [Parameter(ParameterSetName = 'Reset')]
        [switch]
        $Reset
    )

    if ($PSCmdlet.ShouldProcess($script:ConfigPath, "Update configuration file")) {
        $CurrentSettings = if (Test-Path $script:ConfigPath) {
            Get-Content -Path $script:ConfigPath | ConvertFrom-Json
        }
        else {
            $ConfigRoot = $script:ConfigPath | Split-Path -Parent

            if (-not (Test-Path $ConfigRoot)) {
                New-Item -ItemType Directory -Path $ConfigRoot > $null
            }

            [PSCustomObject]$script:DefaultSettings
        }

        $NewSettings = switch ($PSCmdlet.ParameterSetName) {
            'Single' {
                $CurrentSettings |
                    Select-Object -Property *, @{ Name = $Name; Expression = { $Value } } -ExcludeProperty $Name
            }
            'Multiple' {
                $Properties = @(
                    '*'
                    foreach ($key in $Settings.Keys) {
                        @{
                            Name       = $key
                            Expression = { $Settings[$key] }.GetNewClosure()
                        }
                    }
                )
                $CurrentSettings |
                    Select-Object -Property $Properties -ExcludeProperty $Settings.Keys.ForEach{ $_ }
            }
            'Reset' {
                $CurrentSettings
            }
        }

        $NewSettings |
            ConvertTo-Json |
            Set-Content -Path $script:ConfigPath
    }
}
