using namespace System.Management.Automation.Language

$SyntaxTree = (Get-Command "Z:\Scripts\PSKoans\Tests\KoanValidation.Tests.ps1").ScriptBlock.Ast
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
    $Index = $ItCommands.CommandElements.IndexOf($Parameter) + 1
    $ParameterArgument = $ItCommands.CommandElements[$Index]

    # Track back and attempt to find the assignment
    $SimpleTestCases = @(
        $SyntaxTree.FindAll(
            {
                param ($AstItem)

                $AstItem -is [AssignmentStatementAst] -and
                $AstItem.Left.VariablePath.UserPath -eq $ParameterArgument.VariablePath.UserPath
            }, $true
        ).Right.Expression.SafeGetValue()
    ).Count

    $Variables = $TestCases.PipelineElements.Extent.Text -match '\$([a-z0-9_]+|\{.+\})'

    $TestCasesExpressions = @(
        $Variables | ForEach-Object {
            $Var = $_

            $SyntaxTree.FindAll(
                {
                    param($AstItem)
                    $AstItem -is [AssignmentStatementAst] -and
                    $AstItem.Left.Extent.Text -eq $Var
                }, $true
            ).Extent.Text | Invoke-Expression
        }
    ).Count
}

return $SimpleTestCases + $TestCasesExpressions + ($ItCommands.Count - $Parameter.Count)