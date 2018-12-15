function Get-Blank {
    <#
    .SYNOPSIS
        Returns $null
    .DESCRIPTION
        Doesn't return any output. This function exists to permit tokens such as __
        to be used without quotation marks where they would be situationally appropriate.
    .EXAMPLE
        PS> Get-Blank
        <no output>
    .EXAMPLE
        PS> __
        <no output>
    .NOTES
        Author: Joel Sallow
        Module: PSKoans
    .LINK
        https://github.com/vexx32/PSKoans
    #>
    [CmdletBinding()]
    [OutputType([void])]
    [Alias('__', 'FILL_ME_IN')]
    param()

    Write-Verbose "I AIN'T DOIN' NOTHIN'!!!"

    $null
}