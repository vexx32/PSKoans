function Assert-UnblockedFile {
    <#
    .SYNOPSIS
        Asserts that the file is not a file is blocked.

    .DESCRIPTION
        Files may be blocked when copied from Internet zones on Windows. Blocked files will have an alternate NTFS
        stream named Zone.Identifier.

        This command raises a terminating error is the file at the specified path is blocked.

        This check is skipped if the platform is not Windows or the file does not exist.

    .PARAMETER FileInfo
        An instance of System.IO.FileInfo to test.

    .PARAMETER PassThru
        If `-PassThru` is specified, the command will emit the input path value back to the output stream.

    .INPUTS
        System.IO.FileInfo
    
    .NOTES
        Author: Joel Sallow (@vexx32)

    .EXAMPLE
        PS> Get-ChildItem -Recurse -Filter *.Koans.ps1 | Assert-UnblockedFile
        If the file is not in use, nothing happens and nothing is returned. If in use, an exception is thrown.
    
    .EXAMPLE
        PS> Get-ChildItem -Recurse -Filter *.Koans.ps1 | Assert-UnblockedFile -PassThru
        Directory: C:\GitHub\PSKoans\PSKoans\Koans\Cmdlets 1
        LastWriteTime  Length Name
        -------------  ------ ----
        1/29/2023 12:36:33 AM  1.22kb AboutCompareObject.Koans.ps1
        ...
        The file was not in use, so no exception was thrown. Since we specified -PassThru, each FileInfo passed in is returned back to the output stream.
    #>

    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.IO.FileInfo]
        $FileInfo,

        [Switch]
        $PassThru
    )

    process {
        if ($PSVersionTable.PSEdition -ne 'Desktop' -and $PSVersionTable.Platform -ne 'Win32NT') {
            if ($PassThru) {
                return $FileInfo
            }
        }

        if (-not $FileInfo.Exists) {
            if ($PassThru) {
                return $FileInfo
            }
        }

        if (Get-Content -Path $FileInfo.FullName -Stream Zone.Identifier -ErrorAction Ignore) {
            $ErrorDetails = @{
                ExceptionType    = 'System.IO.FileLoadException'
                ExceptionMessage = 'Could not read the koan file "{0}". The file is blocked and may have been copied from an Internet location. Use the Unblock-File to remove the block on the file.' -f $FileInfo.FullName
                ErrorId          = 'PSKoans.KoanFileIsBlocked'
                ErrorCategory    = 'ReadError'
                TargetObject     = $FileInfo
            }
            $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
        } else {
            if ($PassThru) {
                return $FileInfo
            }
        }
    }
}
