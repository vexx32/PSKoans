$ProjectRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', ''
$ModuleFolder = "$ProjectRoot\PSKoans"
Import-Module $ModuleFolder -Prefix "TST"

InModuleScope 'PSKoans' {
    Describe 'Get-Blank' {

        It 'should output $null' {
            Get-TSTBlank | Should -Be $null
        }

        $TestCases = '__', 'FILL_ME_IN' | ForEach-Object {@{Alias = $_}}
        It 'should be called by alias <Alias>' -TestCases $TestCases {
            param($Alias)
            Mock Get-TSTBlank

            Invoke-Expression $Alias

            Assert-MockCalled -CommandName Get-TSTBlank
        }
    }

    Describe 'Initialize-KoanDirectory' {

    }
}