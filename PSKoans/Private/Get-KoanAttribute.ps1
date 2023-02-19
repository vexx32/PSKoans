using namespace System.Management.Automation.Language

function Get-KoanAttribute {
    <#
    .SYNOPSIS
        Get the KoanAttribute from a file.
    .DESCRIPTION
        Modified koan file parser that avoids "using module" statements. Semantic checks for using module include
        invoking "Get-Module -ListAvailable" which adds a considerable delay when parsing individual files.
    .PARAMETER Path
        The path to a Koan file.
    .EXAMPLE
        Get-KoanAttribute -Path C:\userKoanDir\Foundations\AboutArrays.Koans.ps1

        Returns the KoanAttributeInfo from the AboutArrays.Koans.ps1 file.
    .NOTES
        Author: Joel Sallow (@vexx32)
    #>

    [CmdletBinding()]
    [OutputType('PSKoans.KoanAttributeInfo')]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('PSPath')]
        [string]
        $Path
    )

    begin {
        $defaultModule = [KoanAttribute]::new().Module
    }

    process {
        try {
            $ast = Get-KoanAst -Path $Path
            $attributeAst = $ast.Find(
                {
                    param ( $node )

                    $node -is [AttributeAst] -and
                    $node.TypeName.Name -in 'Koan', 'KoanAttribute'
                },
                $false
            )
            if (-not $attributeAst) {
                return
            }

            $namedArguments = $attributeAst.NamedArguments | Group-Object ArgumentName -AsHashTable -AsString

            [PSCustomObject]@{
                Position   = $namedArguments['Position'].Argument.SafeGetValue()
                Module     = if ($namedArguments.Contains('Module')) {
                    $namedArguments['Module'].Argument.SafeGetValue()
                }
                else {
                    $defaultModule
                }
                PSTypeName = 'PSKoans.KoanAttributeInfo'
            }
        } catch {
            $ErrorDetails = @{
                Exception     = $_.Exception
                ErrorId       = 'PSKoans.KoanAttributeParserFailed'
                ErrorCategory = 'OperationStopped'
                TargetObject  = $Path
            }
            Write-Error -ErrorRecord (New-PSKoanErrorRecord @ErrorDetails)
        }
    }
}
