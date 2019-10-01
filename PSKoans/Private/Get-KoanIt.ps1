using namespace System.Management.Automation.Language

function Get-KoanIt {
    <#
    .SYNOPSIS
        Get the It blocks from AST.

    .DESCRIPTION
        Returns all CommandAst nodes for the It command from a specific Koan file.

    .PARAMETER Path
        The path to the file to search.

    .EXAMPLE
        Get-KoanIt -Path C:\userKoanDir\Foundations\AboutArrays.Koans.ps1

        Returns all It blocks from the AboutArrays topic.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('FullName')]
        [string]
        $Path
    )

    process {
        $ast = Get-KoanAst -Path $Path
        $koanList = $ast.FindAll(
            {
                param ( $node )

                $node -is [CommandAst] -and $node.GetCommandName() -eq 'It'
            },
            $true
        )

        foreach ($koan in $koanList) {
            $contextName = ''
            $parentAst = $koan
            do {
                $parentAst = $parentAst.Parent
                if ($parentAst -is [CommandAst] -and $parentAst.GetCommandName() -eq 'Context') {
                    $contextName = $parentAst.CommandElements[1].Value
                }
            } while ($parentAst -and -not $contextName)

            [PSCustomObject]@{
                ID      = '{0}/{1}' -f $contextName, $koan.CommandElements[1].Value
                Name    = $koan.CommandElements[1].Value
                Context = $contextName
                Ast     = $koan
            }
        }
    }
}
