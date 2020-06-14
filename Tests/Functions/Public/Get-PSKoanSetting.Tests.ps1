#Requires -Modules PSKoans

Describe 'Get-PSKoanSetting' {

    BeforeAll {
        $configFilePath = 'TestDrive:/config.json'
        InModuleScope 'PSKoans' -Parameters @{ Path = $configFilePath } {
            param($Path)
            $script:OldConfigPath = $script:ConfigPath
            $script:ConfigPath = $Path
        }

        ${/} = [IO.Path]::DirectorySeparatorChar
    }

    AfterAll {
        InModuleScope 'PSKoans' {
            $script:ConfigPath = $script:OldConfigPath
        }
    }

    Context 'Settings file does not exist' {

        BeforeAll {
            Mock 'Set-PSKoanSetting' -ParameterFilter { $Settings -is [hashtable] }
            $DefaultSettings = InModuleScope 'PSKoans' { $script:DefaultSettings }
        }
`
        It 'returns the default settings' {
            $Result = Get-PSKoanSetting
            $Result | Should -BeOfType [PSCustomObject]
            $Result.KoanLocation | Should -BeExactly "$HOME${/}PSKoans"
            $Result.Editor | Should -BeExactly 'code'
        }

        It 'calls Set-PSKoanSetting to set the default settings' {
            Should -Invoke 'Set-PSKoanSetting' -Scope Context
        }
    }

    Context 'Settings file does exist' {

        BeforeAll {
            [PSCustomObject]@{
                KoanLocation = "TestLocation"
                Editor       = "TestEditor"
            } |
                ConvertTo-Json |
                Set-Content -Path $configFilePath
        }

        It 'returns all settings if none are specified' {
            $Result = Get-PSKoanSetting
            $Result.KoanLocation | Should -BeExactly 'TestLocation'
            $Result.Editor | Should -BeExactly 'TestEditor'
        }

        It 'returns only the specified setting with -Name <Name>' -TestCases @(
            @{ Name = 'KoanLocation'; Expected = 'TestLocation' }
            @{ Name = 'Editor'; Expected = 'TestEditor' }
        ) {
            Get-PSKoanSetting -Name $Name | Should -BeExactly $Expected
        }
    }
}
