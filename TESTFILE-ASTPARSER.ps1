using namespace System.Management.Automation.Language

$SyntaxTree = {
    Describe 'Test Thing' {
        It 'should manage to work with <Item>' {
            param($Item)
            $Item | Should -BeLessOrEqual 10
        } -TestCases @{
            Item = 1
        }, @{
            Item = 3
        }, @{
            Item = 5
        }, @{
            Item = 10
        }
    }
}.Ast
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
    $TestCases = @(
        $ParameterValues = $SyntaxTree.FindAll(
            {
                param ($AstItem)

                $AstItem -is [AssignmentStatementAst] -and
                $AstItem.Left.VariablePath.UserPath -eq $ParameterArgument.VariablePath.UserPath
            }, $true
        ).Right

        if ($ParameterValues.Expression) {
            $ParameterValues.Expression.SafeGetValue()
        }
    ).Count

    $Variables = $TestCases.PipelineElements.Extent.Text -match '\$([a-z0-9_]+|\{.+\})'
}

return $TestCases + ($ItCommands.Count - $Parameter.Count)