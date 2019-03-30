﻿function Initialize-KoanDirectory {
    <#
	.SYNOPSIS
        Provides a blank slate for Koans.
	.DESCRIPTION
        If Koans folder already exists, the folder(s) are overwritten. Otherwise a new folder
        structure is produced.
    .PARAMETER Topic
        Specifies specific koan topics to reset to the blank state.
    .NOTES
        Author: Joel Sallow
        Module: PSKoans
    .LINK
        https://github.com/vexx32/PSKoans
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High")]
    [OutputType([void])]
    param(
        [Parameter()]
        [string[]]
        $Topic
    )

    $KoanFolder = Get-PSKoanLocation

    if ($Topic) {
        $KoanList = Get-ChildItem -Path $KoanFolder -Recurse -Filter *.Koans.ps1 |
            Where-Object { $_.BaseName -replace '\.Koans$' -in $Topic }

        foreach ($Koan in $KoanList) {
            $TopicName = $Koan.Basename -replace '\.Koans$'

            if ($PSCmdlet.ShouldProcess($TopicName, "Reset koan topic")) {
                $OriginalFile = Join-Path $script:ModuleRoot -ChildPath 'Koans' |
                    Get-ChildItem -Recurse -Filter $Koan.Name

                Write-Verbose "Restoring $TopicName to a blank slate"
                $OriginalFile | Copy-Item -Destination $Koan.Fullname -Force
            }
        }
    }
    else {
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

    Write-Verbose "Koan restoration completed."
}
