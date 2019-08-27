# This is required due to having to parse the KoanAttribute to verify the correct files are returned
# Using a relative path to the module being tested removes duplicate loading of the module.
using module ..\..\..\PSKoans\PSKoans.psd1

${global:Test Root} = $PSScriptRoot

InModuleScope 'PSKoans' {
    Describe 'Measure-Koan' {
        It 'counts the number of tests in <File>' {
            param($File, $ExpectedValue)

            Get-Item -Path $File |
                Get-Command { $_.FullName } |
                Measure-Koan |
                Should -Be $ExpectedValue
        } -TestCases @{
            File          = "${global:Test Root}/ControlTests/Measure-Koan.Control_Tests.ps1"
            ExpectedValue = 3
        }, @{
            File          = "${global:Test Root}/../Public/Get-Blank.Tests.ps1"
            ExpectedValue = 3
        }
    }
}
