using namespace System.Management.Automation.Language

function Get-KoanAttribute {
    <#
    .SYNOPSIS
        Get the KoanAttribute from a file.
    .DESCRIPTIOn
        Modified koan file parser that avoids "using module" statements. Semantic checks for using module include
        invoking "Get-Module -ListAvailable" which adds a considerable delay when parsing individual files.
    #>

    [CmdletBinding()]
    [OutputType([KoanAttribute])]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('PSPath')]
        [string]
        $Path
    )

    process {
        try {
            $tokens = $errors = $null

            # Remove the "using module" line. Avoids a slow call to Get-Module -ListAvailable from "using module".
            $content = Get-Content -Path $Path |
                Where-Object { -not $_.StartsWith('using module', [StringComparison]::InvariantCultureIgnoreCase) } |
                Out-String

            $ast = [Parser]::ParseInput(
                $content,
                [Ref]$tokens,
                [Ref]$errors
            )

            $ast.GetScriptBlock().Attributes.Where{ $_.TypeId.Name -eq 'KoanAttribute' }
        } catch {
            $pscmdlet.ThrowTerminatingError($_)
        }
    }
}