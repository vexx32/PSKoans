$CommandName = @(
    'Get-Karma'
    'Get-PSKoan'
    'Reset-PSKoan'
    'Show-Karma'
    'Update-PSKoan'
)

#region Topic completer

$Params = @{
    CommandName   = $CommandName
    ParameterName = 'Topic'
    ScriptBlock   = {
        param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

        $Values = (Get-PSKoan -Scope Module -IncludeModule *).Topic
        return @($Values) -like "$WordToComplete*"
    }
}
Register-ArgumentCompleter @Params

#endregion

#region Module / IncludeModule completer

$Params = @{
    CommandName   = $CommandName
    ParameterName = 'Module'
    ScriptBlock   = {
        param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

        $Values = Get-Module PSKoans |
            Select-Object -ExpandProperty ModuleBase |
            Join-Path -ChildPath 'Koans/Modules' |
            Get-ChildItem -Directory |
            Select-Object -ExpandProperty Name

        return @($Values) -like "$WordToComplete*"
    }
}
Register-ArgumentCompleter @Params

$Params.ParameterName = 'IncludeModule'
Register-ArgumentCompleter @Params

#endregion