function Invoke-Advice
{
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
	Param (
		[string]
		$Name = "*"
	)
	
	begin
	{
		$adviceFolder = Join-Path (Join-Path $script:ModuleFolder 'Data') 'Advice'
		
		function Write-Line
		{
			[CmdletBinding()]
			param (
				[string]
				$Line
			)
			
			$width = $host.UI.RawUI.WindowSize.Width
			
			# Ugly mode since width either not detectable or too small to bother
			if ($width -lt 20) { Write-Host "    $Line" }
			else
			{
				$remainingLine = $Line.TrimEnd()
				$lines = @()
				
				while ($remainingLine.Length -gt ($width - 4))
				{
					$subString = $remainingLine.Substring(0, ($width - 4))
					$end = ($subString -split " |-")[-1]
					$lines += $subString.Substring(0, ($subString.Length - $end.Length)).TrimEnd()
					$remainingLine = $remainingLine.Substring(($subString.Length - $end.Length))
				}
				$lines += $remainingLine
				
				foreach ($lineItem in $lines)
				{
					Write-Host "    $lineItem"
				}
			}
		}
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