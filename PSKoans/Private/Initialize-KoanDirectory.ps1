﻿function Initialize-KoanDirectory {
    <#
	.SYNOPSIS
        Provides a blank slate for Koans.
	.DESCRIPTION
        If Koans folder already exists, the folder(s) are overwritten. Otherwise a new folder
        structure is produced.
    .NOTES
        Author: Joel Sallow
        Module: PSKoans
    .LINK
        https://github.com/vexx32/PSKoans
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