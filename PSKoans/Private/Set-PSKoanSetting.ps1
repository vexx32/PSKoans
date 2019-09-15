function Get-PSKoanSetting {
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
    switch ($PSCmdlet.ParameterSetName) {
        'Single' {
            @{ $Name = $Value } | Export-Configuration -Scope User
        }
        'Multiple' {
            $Settings | Export-Configuration -Scope User
        }
    }
    $Configuration = Import-Configuration
}
