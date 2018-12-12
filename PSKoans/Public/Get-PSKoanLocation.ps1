function Get-PSKoanLocation {
    <#
    .SYNOPSIS
    Retrieves the set folder location where PSKoans' koan files are stored.

    .DESCRIPTION
    Returns the module-scoped PSKoanLocation variable.

    .EXAMPLE
    Get-PSKoanLocation

    C:\Users\Timmy\PSKoans
    #>
    [CmdletBinding()]
    param()

    if ($script:PSKoanLocation) {
        $script:PSKoanLocation
    }
    else {
        throw [System.IO.DirectoryNotFoundException]::new('PSKoans folder location has not been defined.')
    }
}