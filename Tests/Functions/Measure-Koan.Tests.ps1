#Requires -Module PSKoans

InModuleScope 'PSKoans' {
    Describe 'Measure-Koan' {

        It 'should correctly count the number of It blocks in a file' {
            Get-Item -Path "$script:ModuleFolder\..\Tests\Functions\Measure-Koan.Tests.ps1" |
            Get-Command {$_.FullName} |
                Measure-Koan |
                Should -Be 1
        }
    }
}