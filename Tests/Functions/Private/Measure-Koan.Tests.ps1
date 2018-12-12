using module PSKoans

${global:Test Root} = $PSScriptRoot

InModuleScope 'PSKoans' {
    Describe 'Measure-Koan' {

        It 'counts the number of tests in <File>' {
            param($File, $ExpectedValue)

            Get-Item -Path $File |
                Get-Command {$_.FullName} |
                Measure-Koan |
                Should -Be $ExpectedValue
        } -TestCases @{
            File          = "${global:Test Root}\ControlTests\Measure-Koan.Control_Tests.ps1"
            ExpectedValue = 3
        }, @{
            File          = "${global:Test Root}\..\Public\Get-Blank.Tests.ps1"
            ExpectedValue = 1
        }
    }
}