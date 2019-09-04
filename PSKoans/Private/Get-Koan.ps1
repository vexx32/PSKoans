function Get-Koan {
    <#
    .SYNOPSIS
        Returns a sorted list of koans.

    .DESCRIPTION
        Returns a sorted list of all koans, or optionally only those that match the specified criteria.

    .PARAMETER Topic
        Specify one or more topic names or patterns to filter the list. Wildcards are permitted.

    .EXAMPLE
        Get-Koan

        Returns all koans in the PSKoans library folder.
    #>

    [CmdletBinding()]
    [OutputType([System.IO.FileInfo])]
    param(
        [Parameter(Position = 0, ValueFromPipeline)]
        [string[]]
        $Topic
    )
    begin {
        $Topics = [System.Collections.Generic.List[string]]::new()
    }
    process {
        if ($PSBoundParameters.ContainsKey('Topic')) {
            $Topics.AddRange($Topic)
        }
    }
    end {
        $TopicRegex = ConvertFrom-WildcardPattern -Pattern $Topics

        Get-ChildItem -Path (Get-PSKoanLocation) -Recurse -Filter '*.Koans.ps1' |
            Where-Object { -not $PSBoundParameters.ContainsKey('Topic') -or $_.BaseName -replace '\.Koans$' -match $TopicRegex } |
            ForEach-Object {
                if ($PSVersionTable.PSEdition -ne 'Desktop' -and $PSVersionTable.Platform -ne 'Win32NT') {
                    return $_
                }

                if (Get-Content -LiteralPath $_.PSPath -Stream Zone.Identifier -ErrorAction SilentlyContinue) {
                    $ErrorDetails = @{
                        ExceptionType    = 'System.IO.FileLoadException'
                        ExceptionMessage = 'Could not read the koan file. The file is blocked and may have been copied from an Internet location. Use the Unblock-File to remove the block on the file.'
                        ErrorId          = 'PSKoans.KoanFileIsBlocked'
                        ErrorCategory	 = 'ReadError'
                        TargetObject	 = $_.FullName
                    }
                    $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
                }

                $_
            } |
            Get-Command { $_.FullName } |
            Where-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }.Count -gt 0 } |
            Sort-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }.Position }
    }
}
