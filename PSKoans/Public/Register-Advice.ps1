function Register-Advice {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Register-Advice.md')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('AllUsersAllHosts', 'AllUsersCurrentHost', 'CurrentUserAllHosts', 'CurrentUserCurrentHost')]
        [string]
        $TargetProfile = 'CurrentUserCurrentHost'
    )

    $ProfilePath = $Profile.$TargetProfile

    if ($PSCmdlet.ShouldProcess("$TargetProfile PowerShell profile", 'Register Show-Advice')) {
        $ProfileFolder = Split-Path -Path $ProfilePath

        if (-not (Test-Path $ProfileFolder)) {
            New-Item $ProfileFolder -ItemType Directory -Force > $null
        }

        if (-not (Test-Path $ProfilePath)) {
            Set-Content -Path $ProfilePath -Value 'Show-Advice'
        }
        elseif (-not ($ProfilePath | Select-String -Pattern '(Show|Get)-Advice' -Quiet)) {
            'Show-Advice' | Add-Content $ProfilePath
        }
    }
}
