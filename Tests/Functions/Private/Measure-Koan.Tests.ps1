using module PSKoans

InModuleScope 'PSKoans' {
    Describe 'Measure-Koan' {

        It 'counts the number of tests in <File>' {
            param($File, $ExpectedValue)

            Get-Item -Path $File |
                Get-Command {$_.FullName} |
                Measure-Koan |
                Should -Be $ExpectedValue
        } -TestCases @{
            File          = "$script:ModuleFolder\..\Tests\DummyKoans\Measure-Koan.Control_Tests.ps1"
            ExpectedValue = 3
        }, @{
            File          = "$script:ModuleFolder\..\Tests\Functions\Public\Get-Blank.Tests.ps1"
            ExpectedValue = 1
        }
    }
}