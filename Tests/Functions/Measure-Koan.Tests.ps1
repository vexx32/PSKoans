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
            File          = "$env:BUILD_SOURCESDIRECTORY\Tests\Functions\Measure-Koan_Tests\TestFile.Tests.ps1"
            ExpectedValue = 3
        }, @{
            File          = "$env:BUILD_SOURCESDIRECTORY\Tests\Functions\Get-Blank.Tests.ps1"
            ExpectedValue = 1
        }
    }
}