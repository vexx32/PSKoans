function Get-PSKoanFile {
    <#
    .SYNOPSIS
        Get the paths for module and user koan topics.

    .DESCRIPTION
        Returns objects describing the file paths for each topic.

    .PARAMETER Topic
        Specify one or more topic names or patterns to filter the list.

    .EXAMPLE
        Get-PSKoanFile

        Returns all paths for all topics available in the module's Koan directory.

    .EXAMPLE
        Get-PSKoanFile -Topic AboutArrays

        Returns path information for the AboutArrays topic.
    #>

    [CmdletBinding()]
    [OutputType([PSObject[]])]
    param(
        [Parameter()]
        [string[]]
        $Topic
    )

    begin {
        $ParentPathPattern = [regex]::Escape((Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'))
        $KoanFolder = Get-PSKoanLocation
    }

    process {
        $TopicRegex = ConvertFrom-WildcardPattern -Pattern $Topic

        Join-Path -Path $script:ModuleRoot -ChildPath 'Koans' |
            Get-ChildItem -Recurse -Filter *.Koans.ps1 |
            Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -match $TopicRegex } |
            ForEach-Object {
                $PathFragment = $_.Fullname -replace $ParentPathPattern

                [PSCustomObject]@{
                    Topic          = $_.BaseName -replace '\.koans$'
                    ModuleFilePath = $_.FullName
                    UserFilePath   = Join-Path -Path $KoanFolder -ChildPath $PathFragment
                }
            }
    }
}
