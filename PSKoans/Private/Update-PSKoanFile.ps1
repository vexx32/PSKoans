function Update-PSKoanFile {
    <#
    .SYNOPSIS
        Update the koans for a specific topic.

    .DESCRIPTION
        Update a user Koan topic with new koans.

        Existing answers are preserved. Expired koans will be removed and new koans will be added.

    .PARAMETER Topic
        Updates the specified topic from the module.

    .EXAMPLE
        Update-PSKoanFile -Topic AboutArrays

        Updates the AboutArrays topic with any new koans from the module.
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param(
        [Parameter()]
        [Alias('Koan', 'File')]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter()]
        [SupportsWildcards()]
        [string[]]
        $Module,

        [Parameter()]
        [SupportsWildcards()]
        [string[]]
        $IncludeModule
    )

    $PSBoundParameters.Remove('Confirm') > $null
    $PSBoundParameters.Remove('WhatIf') > $null
    Get-PSKoan @PSBoundParameters | ForEach-Object {
        $moduleKoans = Get-KoanIt -Path $_.Path | ForEach-Object {
            [PSCustomObject]@{
                ID   = $_.ID
                Name = $_.Name
                Ast  = $_.Ast
            }
        } | Group-Object -Property ID -AsHashTable -AsString

        if (-not $moduleKoans) {
            # Handles topics which do not have It blocks.
            return
        }

        $path = Get-PSKoanLocation | Join-Path -ChildPath $_.RelativePath

        if (Test-Path -Path $path) {
            $userKoans = Get-KoanIt -Path $path
            $userKoansHash = $userKoans | Group-Object ID -AsHashTable -AsString

            if ($moduleKoans.Keys.Where{ -not ($userKoansHash -and $userKoansHash.Contains($_)) }) {
                $content = Get-Content -Path $_.Path -Raw

                $userKoans |
                    Where-Object { $moduleKoans.Contains($_.ID) } |
                    Select-Object -Property @(
                        'ID'
                        'Name'
                        'Ast'
                        @{ Name = 'SourceAst'; Expression = { $moduleKoans[$_.ID].Ast }}
                    ) |
                    Sort-Object { $_.SourceAst.Extent.StartLineNumber } -Descending |
                    ForEach-Object {
                        # Replace the content of the koan with the users content.
                        $content = $content.Remove(
                            $_.SourceAst.Extent.StartOffset,
                            ($_.SourceAst.Extent.EndOffset - $_.SourceAst.Extent.StartOffset)
                        ).Insert(
                            $_.SourceAst.Extent.StartOffset,
                            $_.Ast.Extent.Text
                        )
                    }

                if ($PSCmdlet.ShouldProcess($path, 'Updating Koan File')) {
                    Set-Content -Path $path -Value $content.TrimEnd() -NoNewline
                }
            }
        }
        else {
            Write-Warning ('Unexpected error, the koan topic {0} does not exist in the user store' -f $_.Name)
        }
    }
}
