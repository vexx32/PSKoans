using namespace System.Management.Automation.Language

function Get-KoanAst {
    <#
    .SYNOPSIS
        Get the AST for a Koan.

    .DESCRIPTION
        Parse the content of a Koan file into an AST. Ignores "using module" statements.

    .PARAMETER Path
        The path to a Koan file.

    #>

    [CmdletBinding()]
    [OutputType([System.Management.Automation.Language.ScriptBlockAst])]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('PSPath')]
        [string]
        $Path
    )

    process {
        try {
            if (-not (Test-Path $Path)) {
                return
            }

            $tokens = $errors = $null

            # Remove the "using module" line. Avoids a slow call to Get-Module -ListAvailable from "using module".
            $content = Get-Content -Path $Path -Raw
            foreach ($match in [Regex]::Matches($content, 'using module \S+')) {
                $content = $content.Remove(
                    $match.Index,
                    $match.Length
                ).Insert(
                    $match.Index,
                    ' ' * $match.Length
                )
            }

            [Parser]::ParseInput(
                $content,
                [Ref]$tokens,
                [Ref]$errors
            )
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
