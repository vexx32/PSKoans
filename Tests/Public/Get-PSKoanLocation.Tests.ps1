#Requires -Modules PSKoans

Describe 'Get-PSKoanLocation' {
    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
    }

    Context 'Normal Behaviour' {

        BeforeAll {
            Mock 'Get-PSKoanSetting' -ParameterFilter { $Name -eq 'KoanLocation' } -MockWith {
                '~/PSKoans'
            } @module

            $Result = Get-PSKoanLocation
        }

        It 'retrieves the koan library location' {
            $Result | Should -Be '~/PSKoans'
        }

        It 'calls Get-PSKoanSetting with -Name "KoanLocation"' {
            Should -Invoke 'Get-PSKoanSetting' -Scope Context @module
        }
    }

    Context 'No Value Available' {

        BeforeAll {
            Mock 'Get-PSKoanSetting' -ParameterFilter { $Name -eq 'KoanLocation' } @module
        }

        It 'throws an error if no value can be retrieved' {
            { Get-PSKoanLocation } | Should -Throw -ExpectedMessage 'PSKoans folder location has not been defined'
        }
    }
}
