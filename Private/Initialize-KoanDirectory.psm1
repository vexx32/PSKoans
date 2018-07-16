function Initialize-KoanDirectory {
	<#
	.NOTES
		Name: Initialize-KoanDirectory
		Author: vexx32
	.SYNOPSIS
		Provides a blank slate for Koans.
	.DESCRIPTION
		If Koans folder already exists, the folder(s) are overwritten. Otherwise a new folder structure is produced.
	.Parameter Destination
		Defaults to home\PSKoans. 
	#>
	[CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
	param(
        [parameter()]
        [string]
        $Destination = ($Home | Join-Path -ChildPath 'PSKoans')
    )
	if ($PSCmdlet.ShouldProcess($Destination, "Restore the koans to a blank slate")) {
		if (Test-Path -Path $Destination) {
			Write-Verbose "Removing the entire koans folder..."
			Remove-Item -Recurse -Path $Destination -Force
		}
		Write-Debug "Copying koans to folder"
		Copy-Item -Path "$PSScriptRoot/Koans" -Recurse -Destination $Destination
		Write-Verbose "Koans copied to '$Destination'"
	}
    #Output the destination, in the event we would want to pipe initialize to get-enlightenment, or maybe we want to assign it to a variable?
    Write-Output $Destination
}