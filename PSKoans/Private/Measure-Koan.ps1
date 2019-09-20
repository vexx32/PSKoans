using namespace System.Management.Automation
using namespace System.Management.Automation.Language

function Measure-Koan {
    <#
    .SYNOPSIS
        Counts the number of koans in the provided ExternalScriptInfo objects.
    .DESCRIPTION
        Traverses the AST of the script blocks taken from the Get-Command output of the koan
        files to find all of the 'It' blocks in order to count the total number of Pester
        tests present in the file.

        When provided with a piped list of ExternalScriptInfo objects, sums the entire
        collection's 'It' blocks and returns a single integer sum.
    .PARAMETER KoanInfo
        Takes an array of ExternalScriptInfo objects (as provided from Get-Command when
        passed the path to an external .ps1 script file).
    .EXAMPLE
        Get-Command .\KoanDirectory\*\*.ps1 | Measure-Koan

        422
    .NOTES
        Measure-Koan is NOT designed to handle dynamic -TestCases values. It will handle
        simple counts of directly attached -TestCases hashtables only if they do not
        contain variables, pipelines, and other dynamic expressions.

        Handling dynamic scripts with pipelines and variables is beyond scope and will
        not be handled; we'd essentially end up reimplementing the PS parser. If it can't
        be got with .GetSafeValue() we simply aren't working with it.

        Author: Joel Sallow
        Module: PSKoans
    .LINK
        https://github.com/vexx32/PSKoans
    #>
    [CmdletBinding()]
    [OutputType([int])]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [PSTypeName('PSKoans.KoanInfo')]
        [object[]]
        $KoanInfo
    )
    begin {
        $KoanCount = 0
    }
    process {
        Write-Verbose "Parsing koan files from [$($KoanInfo.Name -join '], [')]"

        # Find all Pester 'It' commands
        $ItCommands = @(Get-KoanIt -Path $KoanInfo.Path)

        # Find the -TestCases parameters
        $TestCasesParameters = $ItCommands.Ast.CommandElements | Where-Object {
            $_ -is [CommandParameterAst] -and
            $_.ParameterName -eq 'TestCases'
        }

        if ($TestCasesParameters) {
            # Get the right CommandElements indexes for their arguments
            $Indexes = $TestCasesParameters.ForEach{$ItCommands.Ast.CommandElements.IndexOf($_) + 1}
            # Get value of the argument for each -TestCases
            $ParameterArgument = $ItCommands.Ast.CommandElements[$Indexes]

            try {
                $TestCaseCount = $ParameterArgument.SafeGetValue().Count
            }
            catch {
                # We aren't parsing complex or variable expressions, so exit here (violently)
                $ParseException = [ParseException]::new(
                    "Unable to parse unsafe expression in Koan -TestCase syntax.",
                    $_.Exception
                )
                $ErrorRecord = [ErrorRecord]::new(
                    $ParseException,
                    "PSKoans.KoanAstParseError",
                    [ErrorCategory]::ParserError,
                    $ParameterValues.PipelineElements.Extent.Text
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
        }

        $KoanCount += $TestCaseCount + $ItCommands.Count - $TestCasesParameters.Count
    }
    end {
        Write-Verbose "Total Koans: $KoanCount"
        $KoanCount
    }
}
