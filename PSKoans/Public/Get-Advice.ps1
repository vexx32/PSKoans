function Get-Advice {
    <#
		.SYNOPSIS
			Prints a piece of advice to the screen.
		.DESCRIPTION
			Prints a piece of advice to the screen.

			Use Get-Advice to have a random piece of advice shown on each console start
		.PARAMETER Name
			The name of the specific advice to display
		.EXAMPLE
			PS C:\> Get-Advice
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

        Write-Host ""
		Write-Host " Advice of the session:"
    }
    process {
        Get-ChildItem $AdviceFolder -Recurse -File -Filter $Name |
            Get-Random |
            Get-Content |
            Write-ConsoleLine
	}
	end {
        Write-Host ""
    }
}