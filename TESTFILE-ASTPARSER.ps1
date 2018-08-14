using namespace System.Management.Automation
using namespace System.Management.Automation.Language



$ItCommands = $SyntaxTree.FindAll(
    {
        param ($AstItem)

        $AstItem -is [CommandAst] -and $AstItem.GetCommandName() -eq 'It'
    }, $true
)

$Parameter = $ItCommands.CommandElements | Where-Object {
    $_ -is [CommandParameterAst] -and
    $_.ParameterName -eq 'TestCases'
}
if ($Parameter) {
    $Index = $Parameter.ForEach{$ItCommands.CommandElements.IndexOf($_) + 1}
    $ParameterArgument = $ItCommands.CommandElements[$Index]

    try {
        $TestCases = $ParameterArgument.SafeGetValue().Count
    }
    catch {
        # We aren't parsing complex or variable expressions, so exit here (violently)
        $ParseException = [ParseException]::new(
            "Unable to parse unsafe expression in Koan -TestCase syntax.",
            $_.Exception
        )
        $ErrorRecord = [ErrorRecord]::new(
            $ParseException,
            "KoanAstParseError",
            [ErrorCategory]::ParserError,
            $ParameterValues.PipelineElements.Extent.Text
        )
        $PSCmdlet.ThrowTerminatingError($ErrorRecord)
    }
}

return ($TestCases + $ItCommands.Count - $Parameter.Count)