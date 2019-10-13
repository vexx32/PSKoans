#Requires -Modules PSKoans

Describe 'Get-PSKoanSetting' {
    BeforeAll {
        InModuleScope PSKoans {
            $script:ConfigPath = 'TestDrive:/config.json'
        }
        ${/} = [IO.Path]::DirectorySeparatorChar
    }

    Context 'Settings file does not exist' {
        BeforeAll {
            Mock Set-PSKoanSetting { } -ParameterFilter { $Settings -is [hashtable] } -ModuleName PSKoans
            $DefaultSettings = InModuleScope PSKoans { $script:DefaultSettings }
        }

        It 'returns the default settings' {
            $Result = InModuleScope PSKoans { Get-PSKoanSetting }
            $Result | Should -BeOfType [PSCustomObject]
            $Result.KoanLocation | Should -BeExactly "$HOME${/}PSKoans"
            $Result.Editor | Should -BeExactly 'code'
        }

        It 'calls Set-PSKoanSetting to set the default settings' {
            Assert-MockCalled Set-PSKoanSetting -ModuleName PSKoans
        }
    }

    Context 'Settings file does exist' {
        BeforeAll {
            '{"KoanLocation": "TestLocation","Editor": "TestEditor"}' | Set-Content -Path 'TestDrive:/config.json'
        }

        It 'returns all settings if none are specified' {
            $Result = InModuleScope PSKoans { Get-PSKoanSetting }
            $Result.KoanLocation | Should -BeExactly 'TestLocation'
            $Result.Editor | Should -BeExactly 'TestEditor'
        }

        It 'returns only the specified setting with -Name' {
            InModuleScope PSKoans { Get-PSKoanSetting -Name KoanLocation } | Should -BeExactly 'TestLocation'
        }
    }
}
