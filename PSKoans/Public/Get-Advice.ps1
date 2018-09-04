function Get-Advice {
	<#
		.SYNOPSIS
			Prints a piece of advice to the screen.
		.DESCRIPTION
			Prints a piece of advice to the screen.

			Use Register-Advice to have a random piece of advice shown on each console start
		.PARAMETER Name
			The name of the specific advice to display
		.EXAMPLE
			PS C:\> Write-Advice
			Print a random piece of advice to the screen.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Position = 0)]
		[string]
		$Name = "*"
	)
	begin {
		$AdviceFolder = Join-Path $script:ModuleFolder 'Data/Advice'
	}
	process {
		$AdviceItem = Get-ChildItem $AdviceFolder -Recurse -File |
			Where-Object BaseName -like $Name |
			Get-Random

		Write-Host ""
		Write-Host " Advice of the session:"

		foreach ($line in (Get-Content $AdviceItem.FullName)) {
			Write-ConsoleLine $line
		}

		Write-Host ""
	}
}