function Show-Advice {
    <#
		.SYNOPSIS
			Prints a piece of advice to the screen.
		.DESCRIPTION
			Prints a piece of advice to the screen.

			Use Get-Advice to have a random piece of advice shown on each console start
		.PARAMETER Name
			The name of the specific advice to display.
		.EXAMPLE
            Get-Advice

			Print a random piece of advice to the screen.
	#>
    [CmdletBinding()]
    [Alias('Get-Advice')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]
        $Name = "*"
    )
    begin {
        $AdviceFolder = $script:ModuleRoot | Join-Path -ChildPath 'Data/Advice'
    }
    process {
        $AdviceObject = Get-ChildItem -Path $AdviceFolder -Recurse -File -Filter "$Name.json" |
            Get-Random |
            Get-Content |
            ConvertFrom-Json

        $AdviceObject.Title | Write-ConsoleLine -Title
        $AdviceObject.Content | Write-ConsoleLine
    }
    end {}
}
