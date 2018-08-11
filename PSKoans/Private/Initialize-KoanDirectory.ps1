function Initialize-KoanDirectory {
    <#
	.SYNOPSIS
    Provides a blank slate for Koans.

	.DESCRIPTION
    If Koans folder already exists, the folder(s) are overwritten. Otherwise a new folder
    structure is produced.

	.NOTES
    Name: Initialize-KoanDirectory
    Author: vexx32
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    param()
    if ($PSCmdlet.ShouldProcess($env:PSKoans_Folder, "Restore the koans to a blank slate")) {
        if (Test-Path -Path $env:PSKoans_Folder) {
            Write-Verbose "Removing the entire koans folder..."
            Remove-Item -Recurse -Path $env:PSKoans_Folder -Force
        }
        Write-Debug "Copying koans to folder"
        Copy-Item -Path "$script:ModuleFolder\Koans" -Recurse -Destination $env:PSKoans_Folder
        Write-Verbose "Koans copied to '$env:PSKoans_Folder'"
    }
    else {
        Write-Verbose "Operation cancelled; no modifications made to koans folder."
    }
}