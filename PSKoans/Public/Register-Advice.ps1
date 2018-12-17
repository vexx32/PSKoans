function Register-Advice {
    <#
	.SYNOPSIS
		Causes powershell to write a random piece of advice on each start.

	.DESCRIPTION
		Causes powershell to write a random piece of advice on each start.
		This is done by creating / modifying the powershell profile.

	.EXAMPLE
		Register-Advice

		Causes powershell to write a random piece of advice on each start.
#>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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
