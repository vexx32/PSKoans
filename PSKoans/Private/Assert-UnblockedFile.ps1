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

    .INPUTS
        System.IO.FileInfo

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

        if (Get-Content -Path $FileInfo.FullName -Stream Zone.Identifier -ErrorAction SilentlyContinue) {
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
