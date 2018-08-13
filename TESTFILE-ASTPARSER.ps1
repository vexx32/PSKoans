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

        if ($ParameterValues.PipelineElements) {
            $MatchString = '\$(?!\{?(_|PSItem)\}?)([a-z0-9_]+|\{.+\})'
            $Variables = @($ParameterValues.PipelineElements.Extent.Text) -match $MatchString
            $AssignmentExpression = $ParameterValues.Extent.Text

            foreach ($VariableName in $Variables) {

                $VariableValue = $SyntaxTree.FindAll(
                    {
                        param($AstItem)

                        $AstItem -is [AssignmentStatementAst] -and
                        $AstItem.Left.Extent.Text -eq $VariableName
                    }, $true
                ).Right.Extent.Text
                $AssignmentExpression = $AssignmentExpression -replace [RegEx]::Escape($VariableName), "($VariableValue)"
            }
            Invoke-Expression $AssignmentExpression
        }
    ).Count

    $Variables = $TestCases.PipelineElements.Extent.Text -match '\$([a-z0-9_]+|\{.+\})'
}

return $TestCases + ($ItCommands.Count - $Parameter.Count)