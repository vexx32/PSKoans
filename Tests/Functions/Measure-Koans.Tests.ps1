#Requires -Module PSKoans

InModuleScope 'PSKoans' {
    Describe 'Measure-Koans' {

        It 'should correctly count the number of It blocks in a file' {
            Get-Item -Path "$script:ModuleFolder\..\Tests\Functions\Measure-Koans.Tests.ps1" |
            Get-Command {$_.FullName} |
                Measure-Koans |
                Should -Be 1
        }
    }
}