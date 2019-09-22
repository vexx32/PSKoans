function Set-PSKoanSetting {
    <#
    .SYNOPSIS
    Modifies the configuration settings for PSKoans.

    .DESCRIPTION
    Stores configuration data via the PoshCode Configuration module. Module settings
    for PSKoans are stored in the user location / scope.

    .PARAMETER Name
    Specifies which setting value to modify.

    .EXAMPLE
    Get-PSKoanSetting -Name LibraryFolder

    Retrieves the library folder location (exposed to the user via Get-PSKoanLocation).
    #>

    [CmdletBinding(DefaultParameterSetName = 'Single')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Single')]
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
                            @{ Name = $key; Expression = { $Settings[$key] } }
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
