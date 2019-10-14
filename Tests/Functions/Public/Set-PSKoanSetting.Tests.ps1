#Requires -Modules PSKoans

Describe 'Set-PSKoanSetting' {
    BeforeAll {
        InModuleScope 'PSKoans' {
            $script:OldConfigPath = $script:ConfigPath
        }
    }

    BeforeEach {
        $NewConfigPath = InModuleScope 'PSKoans' {
            ($script:ConfigPath = "$TestDrive/config.json")
        }
    }

    AfterAll {
        InModuleScope 'PSKoans' {
            $script:ConfigPath = $script:OldConfigPath
        }
    }

    Context 'Settings file Exists' {

        Describe 'Setting values with -Name and -Value' {
            BeforeAll {
                if (-not (Test-Path $TestDrive)) {
                    New-Item -ItemType File -Path "$TestDrive/config.json"
                }

                $Settings = [PSCustomObject]@{
                    LibraryFolder = "$TestDrive/PSKoans"
                    Editor        = 'code'
                }
                $Settings |
                    ConvertTo-Json |
                    Set-Content -Path $NewConfigPath

                $TestCases = @(
                    @{ Name = 'TestSetting1'; Value = 'TestValue1' }
                    @{ Name = 'LibraryFolder'; Value = "$TestDrive/AltLocation/PSKoans" }
                    @{ Name = 'Editor'; Value = 'code-insiders' }
                )
            }

            AfterAll {
                Remove-Item -Path $NewConfigPath -Force
            }

            It 'should add a new setting: <Name> = <Value>' -TestCases $TestCases {
                param($Name, $Value)

                Set-PSKoanSetting -Name $Name -Value $Value

                Get-PSKoanSetting -Name $Name | Should -BeExactly $Value
                Get-Content -Path $NewConfigPath |
                    ConvertFrom-Json |
                    Select-Object -ExpandProperty $Name |
                    Should -BeExactly $Value
            }
        }

        Context 'Setting values with -Settings Hashtable' {
            BeforeAll {
                if (-not (Test-Path $TestDrive)) {
                    New-Item -ItemType File -Path "$TestDrive/config.json"
                }

                $Settings = [PSCustomObject]@{
                    LibraryFolder = "$TestDrive/PSKoans"
                    Editor        = 'code'
                }
                $Settings |
                    ConvertTo-Json |
                    Set-Content -Path $NewConfigPath
            }

            AfterAll {
                Remove-Item -Path $NewConfigPath -Force
            }

            It 'should add or overwrite multiple new settings' {
                $NewSettings = @{
                    TestSetting2  = "TestValue2"
                    LibraryFolder = "$TestDrive/PSKoans"
                }
                Set-PSKoanSetting -Settings $NewSettings
                $Settings = Get-PSKoanSetting

                $Settings.TestSetting2 | Should -BeExactly $NewSettings.TestSetting2
                $Settings.Editor | Should -BeExactly 'code'
                $Settings.LibraryFolder | Should -BeExactly $NewSettings.LibraryFolder
            }
        }
    }

    Context 'Settings file does not exist' {

        Describe 'Setting values with -Name and -Value' {
            BeforeAll {
                $DefaultSettings = InModuleScope 'PSKoans' { $script:DefaultSettings }
                $TestCases = @(
                    @{ Name = 'TestSetting1' ; Value = 'TestValue1' }
                    @{ Name = 'Editor'; Value = 'TestEditor' }
                    @{ Name = 'LibraryFolder'; Value = "$TestDrive/TestFolder" }
                )
            }

            BeforeEach {
                if (Test-Path -Path $NewConfigPath) {
                    Remove-Item -Path $NewConfigPath
                }
            }

            It 'correctly adds the setting: <Name> = <Value>' -TestCases $TestCases {
                param($Name, $Value)

                $NewConfigPath | Should -Not -Exist
                Set-PSKoanSetting -Name $Name -Value $Value
                $NewConfigPath | Should -Exist

                $NewSettings = Get-PSKoanSetting
                $NewSettings.$Name | Should -BeExactly $Value

                # Other settings should remain as their defaults
                $DefaultSettings.Keys.Where{ $_ -ne $Name }.ForEach{
                    $NewSettings.$_ | Should -BeExactly $DefaultSettings.$_
                }
            }
        }

        Context 'Setting values with -Settings Hashtable' {
            BeforeAll {
                $DefaultSettings = InModuleScope 'PSKoans' { $script:DefaultSettings }
                $TestCases = @(
                    @{ Settings = @{ TestSetting1 = 'TestValue1'; Editor = 'TestEditor' } }
                    @{ Settings = @{ LibraryFolder = "$TestDrive/TestFolder"; TestSetting2 = 'TestValue2' } }
                )
            }

            BeforeEach {
                if (Test-Path -Path $NewConfigPath) {
                    Remove-Item -Path $NewConfigPath
                }

            }

            It 'adds and replaces values: <Settings>' -TestCases $TestCases {
                param($Settings)

                $NewConfigPath | Should -Not -Exist
                Set-PSKoanSetting -Settings $Settings
                $NewConfigPath | Should -Exist

                $NewSettings = Get-PSKoanSetting
                $Settings.Keys.ForEach{
                    $NewSettings.$_ | Should -BeExactly $Settings.$_
                }
                $NewSettings.Keys.Where{ $_ -notin $Settings.Keys }.ForEach{
                    $NewSettings.$_ | Should -BeExactly $DefaultSettings.$_
                }
            }
        }
    }
}
