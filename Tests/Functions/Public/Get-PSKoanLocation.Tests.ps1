#Requires -Modules PSKoans

Describe 'Get-PSKoanLocation' {

    Context 'Normal Behaviour' {

        BeforeAll {
            Mock 'Get-PSKoanSetting' -ParameterFilter { $Name -eq 'KoanLocation' } -MockWith {
                '~/PSKoans'
            }

            $Result = Get-PSKoanLocation
        }

        It 'retrieves the koan library location' {
            $Result | Should -Be '~/PSKoans'
        }

        It 'calls Get-PSKoanSetting with -Name "KoanLocation"' {
            Should -Invoke 'Get-PSKoanSetting' -Scope Context
        }
    }

    Context 'No Value Available' {

        BeforeAll {
            Mock 'Get-PSKoanSetting' -ParameterFilter { $Name -eq 'KoanLocation' }
        }

        It 'throws an error if no value can be retrieved' {
            { Get-PSKoanLocation } | Should -Throw -ExpectedMessage 'PSKoans folder location has not been defined'
        }
    }
}
