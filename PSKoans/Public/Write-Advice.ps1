function Write-Advice {
	<#
		.SYNOPSIS
			Prints a piece of advice to the screen.
		.DESCRIPTION
			Prints a piece of advice to the screen.

			Use Register-Advice to have a random piece of advice shown on each console start
		.PARAMETER Name
			The name of the specific advice to display
		.EXAMPLE
			PS C:\> Invoke-Advice
			Print a random piece of advice to the screen.
	#>
	[CmdletBinding()]
	param(
		[Parameter(Position = 0)]
		[string]
		$Name = "*"
	)

	begin
	{
		$adviceFolder = Join-Path $script:ModuleFolder 'Data/Advice'
	}
	process
	{
		$adviceItem = Get-ChildItem $adviceFolder -Recurse |
		  Where-Object PSIsContainer -EQ $false |
		    Where-Object BaseName -Like $Name |
		      Get-Random
		Write-Host ""
		Write-Host "  Advice of the session:"
		foreach ($line in (Get-Content $adviceItem.FullName))
		{
			Write-Line $line
		}
		Write-Host ""
	}
}