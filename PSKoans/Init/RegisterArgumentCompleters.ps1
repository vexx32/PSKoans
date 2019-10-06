$CommandName = @(
    'Get-Karma'
    'Get-PSKoan'
    'Reset-PSKoan'
    'Show-Karma'
    'Update-PSKoan'
)

$AdviceCommandName = @(
    'Show-Advice'
    'Get-Advice'
)

#region Topic completer

$RegisterParams = @{
    CommandName   = $CommandName
    ParameterName = 'Topic'
    ScriptBlock   = {
        param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

        $Values = (Get-PSKoan -Scope Module -IncludeModule * -SkipAttributeParsing).Topic
        return @($Values) -like "$WordToComplete*"
    }
}
Register-ArgumentCompleter @RegisterParams

#endregion

#region Module / IncludeModule completer

$RegisterParams = @{
    CommandName   = $CommandName
    ParameterName = 'Module'
    ScriptBlock   = {
        param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

        $Values = $script:ModuleRoot |
            Join-Path -ChildPath 'Koans/Modules' |
            Get-ChildItem -Directory |
            Select-Object -ExpandProperty Name

        return @($Values) -like "$WordToComplete*"
    }
}
Register-ArgumentCompleter @RegisterParams

$RegisterParams.ParameterName = 'IncludeModule'
Register-ArgumentCompleter @RegisterParams

#endregion

#region Name completer for *-Advice command names

$RegisterParams = @{
    CommandName   = $AdviceCommandName
    ParameterName = 'Name'
    ScriptBlock   = {
        param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

        $Values = $script:ModuleRoot |
            Join-Path -ChildPath 'Data/Advice' |
            Get-ChildItem -File -Recurse |
            Select-Object @{
                Name       = 'Name';
                Expression = { $_.BaseName.Replace('.Advice', '') }
            } |
            Select-Object -ExpandProperty Name

        return @($Values) -like "$WordToComplete*"
    }
}
Register-ArgumentCompleter @RegisterParams

#endregion
