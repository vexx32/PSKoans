function Initialize-KoanDirectory {
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
    [OutputType([void])]
    param()

    $KoanFolder = Get-PSKoanLocation

    if ($PSCmdlet.ShouldProcess($KoanFolder, "Restore the koans to a blank slate")) {
        if (Test-Path -Path $KoanFolder) {
            Write-Verbose "Removing the entire koans folder..."
            Remove-Item -Recurse -Path $KoanFolder -Force
        }

        Write-Debug "Copying koans to folder"
        Copy-Item -Path "$script:ModuleRoot/Koans" -Recurse -Destination $KoanFolder
        Write-Verbose "Koans copied to '$KoanFolder'"
    }
    else {
        Write-Verbose "Operation cancelled; no modifications made to koans folder."
    }
}