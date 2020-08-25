using module PSKoans
[Koan(Position = 208)]
param()
<#
    ForEach-Object

    As the name implies, ForEach-Object acts like a loop, similar to the native
    foreach keyword.

    It can be used at any point in a pipeline context to perform custom actions
    not otherwise performed by existing cmdlets.

    ForEach-Object optionally takes parameters for Begin and End script blocks,
    allowing it to become a sort of impromptu advanced function of sorts.
#>
Describe 'ForEach-Object' {

    It 'is similar to foreach' {
        $ForEachLoop = foreach ($Number in 1..10) {
            "The number is $Number!"
        }

        $ForEachObject = 1..10 | ForEach-Object {
            "__"
        }

        $ForEachLoop | Should -Be $ForEachObject
    }

    It 'takes Begin and End script blocks' {
        $Output = 1..5 | ForEach-Object -Begin {'__'} -Process {$_} -End {'END'}

        $Output[0] | Should -Be 'BACON'
        '__' | Should -Be $Output[-1]
    }

    It 'can iterate over only a specific property of the objects' {
        $Strings = 'hello', 'goodbye', 'what', 'what', 'you first'
        $Strings | ForEach-Object -MemberName __ | Should -Be @(5, 7, 4, 4, 9)
    }
}
