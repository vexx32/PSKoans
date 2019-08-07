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
        [string[]]
        $Topic
    )

    $params = @{}
    if ($Topic) {
        $params.Topic = $Topic
    }
    Get-PSKoanFilePath @params | ForEach-Object {
        $moduleKoans = Get-PSKoanIt -Path $_.ModuleFilePath | ForEach-Object -Begin {
            $position =  0
        } -Process {
            [PSCustomObject]@{
                ID       = $_.ID
                Position = $position++
                Name     = $_.Name
                Ast      = $_.Ast
            }
        } | Group-Object ID -AsHashTable -AsString

        if (-not $moduleKoans) {
            # Not all files have content right now
            return
        }

        if (Test-Path $_.UserFilePath) {
            $userKoans = Get-PSKoanIt -Path $_.UserFilePath
            $userKoansHash = $userKoans | Group-Object ID -AsHashTable -AsString

            if ($moduleKoans.Keys | Where-Object { -not $userKoansHash -or -not $userKoansHash.Contains($_) }) {
                $content = Get-Content $_.ModuleFilePath -Raw

                $userKoans |
                    Where-Object {
                        $moduleKoans.Contains($_.ID)
                    } |
                    ForEach-Object {
                        [PSCustomObject]@{
                            ID        = $_.ID
                            Position  = $moduleKoans[$_.ID].Position
                            Name      = $_.Name
                            Ast       = $_.Ast
                            SourceAst = $moduleKoans[$_.ID].Ast
                        }
                    } |
                    Sort-Object { $_.SourceAst.Extent.StartLineNumber } -Descending |
                    ForEach-Object {
                        $content = $content.Remove(
                            $_.SourceAst.Extent.StartOffset,
                            ($_.SourceAst.Extent.EndOffset - $_.SourceAst.Extent.StartOffset)
                        ).Insert(
                            $_.SourceAst.Extent.StartOffset,
                            $_.Ast.Extent.Text
                        )
                    }

                if ($pscmdlet.ShouldProcess(('Updating "{0}"' -f $_.UserFilePath))) {
                    Set-Content -Path $_.UserFilePath -Value $content
                }
            }
        } else {
            Write-Warning ('Unexpected error, the koan topic {0} does not exist in the user store' -f $_.UserFilePath)
        }
    }
}