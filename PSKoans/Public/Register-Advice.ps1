function Register-Advice
{
<#
	.SYNOPSIS
		Causes powershell to write a random piece of advice on each start.
	
	.DESCRIPTION
		Causes powershell to write a random piece of advice on each start.
		This is done by creating / modifying the powershell profile.
	
	.EXAMPLE
		PS C:\> Register-Advice
	
		Causes powershell to write a random piece of advice on each start.
#>
	[CmdletBinding()]
	Param (
		
	)
	
	process
	{
		if (-not (Test-Path $profile))
		{
			$folder = Split-Path $PROFILE
			if (-not (Test-Path $folder))
			{
				$null = New-Item $folder -ItemType Directory -Force
			}
			Set-Content -Path $PROFILE -Value 'Invoke-Advice'
		}
		elseif (-not ((Get-Content $PROFILE) -match "Invoke-Advice"))
		{
			[string[]]$lines = Get-Content $PROFILE
			$lines += 'Invoke-Advice'
			$lines | Set-Content $PROFILE
		}
	}
}