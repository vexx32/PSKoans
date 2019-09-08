function Get-PSKoanFile {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoanFile.md')]
    [OutputType([PSObject[]])]
    param(
        [Parameter()]
        [SupportsWildcards()]
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
