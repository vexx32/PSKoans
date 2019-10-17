#Requires -Modules PSKoans

Describe 'Get-PSKoanLocation' {
    BeforeAll {
        Mock Get-PSKoanSetting -ModuleName PSKoans {
            '~/PSKoans'
        } -ParameterFilter { $Name -eq 'KoanLocation' }
    }

    It 'retrieves the koan library location' {
        Get-PSKoanLocation | Should -Be '~/PSKoans'
    }

    It 'calls Get-PSKoanSetting with -Name "LibraryFolder"' {
        Assert-MockCalled Get-PSKoanSetting -ModuleName PSKoans
    }

    It 'throws an error if no value can be retrieved' {
        Mock Get-PSKoanSetting -ModuleName PSKoans -ParameterFilter { $Name -eq 'KoanLocation' }

        { Get-PSKoanLocation } | Should -Throw -ExpectedMessage 'location has not been defined'
    }
}
