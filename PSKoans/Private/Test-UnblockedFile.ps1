function Test-UnblockedFile {
    <#
    .SYNOPSIS
        Tests whether or not a file is blocked.

    .DESCRIPTION
        Files may be blocked when copied from Internet zones on Windows. Blocked files will have an alternate NTFS
        stream named Zone.Identifier.

        This command raises a terminating error is the file at the specified path is blocked.

        This check is skipped if the platform is not Windows or the file does not exist.

    .PARAMETER FileInfo
        The file which should be tested.

    .INPUTS
        System.IO.FileInfo

    #>

    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(ValueFromPipeline)]
        [System.IO.FileInfo]
        $FileInfo
    )

    process {
        if (-not $FileInfo.Exists) {
            return $FileInfo
        }

        if ($PSVersionTable.PSEdition -ne 'Desktop' -and $PSVersionTable.Platform -ne 'Win32NT') {
            return $FileInfo
        }

        if (Get-Content -LiteralPath $_.PSPath -Stream Zone.Identifier -ErrorAction SilentlyContinue) {
            $ErrorDetails = @{
                ExceptionType    = 'System.IO.FileLoadException'
                ExceptionMessage = 'Could not read the koan file. The file is blocked and may have been copied from an Internet location. Use the Unblock-File to remove the block on the file.'
                ErrorId          = 'PSKoans.KoanFileIsBlocked'
                ErrorCategory    = 'ReadError'
                TargetObject     = $_.FullName
            }
            $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
        } else {
            return $true
        }
    }
}
