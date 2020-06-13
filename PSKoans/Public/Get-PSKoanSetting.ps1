function Get-PSKoanSetting {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/main/docs/Get-PSKoanSetting.md')]
    [OutputType([object], [PSCustomObject])]
    param(
        [Parameter()]
        [string]
        $Name
    )

    $Configuration = if (-not (Test-Path $script:ConfigPath)) {
        # No settings file present, create file with default settings
        Set-PSKoanSetting -Settings $script:DefaultSettings -Confirm:$false
        [PSCustomObject]$script:DefaultSettings
    }
    else {
        Get-Content -Path $script:ConfigPath | ConvertFrom-Json
    }

    if ($Name) {
        $Configuration.$Name
    }
    else {
        $Configuration
    }
}
