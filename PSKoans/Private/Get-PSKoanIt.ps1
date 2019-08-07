function Get-PSKoanIt {
    <#
    .SYNOPSIS
        Get the It blocks from AST.

    .DESCRIPTION
        Returns all CommandAst nodes for the It command from a specific Koan file.

    .PARAMETER Path
        The path to the file to search.

    .EXAMPLE
        Get-PSKoanIt -Path C:\userKoanDir\Foundations\AboutArrays.Koans.ps1

        Returns all It blocks from the AboutArrays topic.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    $tokens = $errors = @()

    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $Path,
        [Ref]$tokens,
        [Ref]$errors
    )

    $ast.FindAll(
        {
            param ( $node )

            $node -is [System.Management.Automation.Language.CommandAst] -and
            $node.GetCommandName() -eq 'It'
        },
        $true
    ) | ForEach-Object {
        $contextName = ''
        $parentAst = $_
        do {
           $parentAst = $parentAst.Parent
           if ($parentAst -is [System.Management.Automation.Language.CommandAst] -and $parentAst.GetCommandName() -eq 'Context') {
               $contextName = $parentAst.CommandElements[1].Value
           }
        } until (-not $parentAst -or $contextName)

        [PSCustomObject]@{
            ID      = '{0}\{1}' -f $contextName, $_.CommandElements[1].Value
            Name    = $_.CommandElements[1].Value
            Context = $contextName
            Ast     = $_
        }
    }
}
