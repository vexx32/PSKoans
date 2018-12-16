using namespace System.Text

function Get-Koan {
    <#
    .SYNOPSIS
        Returns a sorted list of koans.

    .DESCRIPTION
        Returns a sorted list of all koans, or optionally only those that match the specified criteria.

    .PARAMETER Topic
        Speficy one or more topic names or patterns to filter the list. Regex matching is permitted.

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
        if ($PSBoundParameters.ContainsKey('Topic')) {
            $PatternBuilder = [StringBuilder]::new()
        }
    }
    process {
        if ($PSBoundParameters.ContainsKey('Topic')) {
            foreach ($Item in $Topic) {
                if ($PatternBuilder.Length -gt 0) {
                    $PatternBuilder.AppendFormat('|{0}', $Item) > $null
                }
                else {
                    $PatternBuilder.Append($Item) > $null
                }
            }
        }
    }
    end {
        Get-ChildItem -Path (Get-PSKoanLocation) -Recurse -Filter '*.Koans.ps1' |
            Where-Object { -not $PSBoundParameters.ContainsKey('Topic') -or $_.BaseName -match $PatternBuilder.ToString() } |
            Get-Command { $_.FullName } |
            Where-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }.Count -gt 0 } |
            Sort-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }.Position }
    }
}
