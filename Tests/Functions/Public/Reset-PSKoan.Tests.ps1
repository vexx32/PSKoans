#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Reset-PSKoan' {
        BeforeAll {
            Mock Get-PSKoan {
                [PSCustomObject]@{
                    Path         = Join-Path $TestDrive 'Module\AboutSomething.ps1'
                    RelativePath = 'Koans\AboutSomething.ps1'
                }
            }
            New-Item -Path (Join-Path $TestDrive 'Module') -ItemType Directory
            New-Item -Path (Join-Path $TestDrive 'Koans') -ItemType Directory

            Set-Content -Path (Get-PSKoan).Path -Value @'
                Describe 'AboutSomething' {
                    It 'existing content' {
                        __ | Should -Be 1
                    }

                    It 'reset content' {
                        __ | Should -Be 2
                    }

                    Context 'first' {
                        It 'nested reset content' {
                            __ | Should -Be 3
                        }
                    }

                    Context 'second' {
                        It 'nested reset content' {
                            __ | Should -Be 4
                        }
                    }
                }
'@

            $userFilePath = (Get-PSKoan).UserFilePath
        }

        Context 'User file exists, It block exists' {
            BeforeAll {
                Mock Set-Content
                Mock Copy-Item
                Mock Test-Path { $true }
            }

            It 'When Name is supplied, updates an existing user file' {
                Reset-PSKoan -Name 'existing content'

                Assert-MockCalled Set-Content -Times 1 -Scope -It
                Assert-MockCalled Copy-Item -Times 0 -Scope It
            }

            It 'When Context is supplied, updates an existing user file' {
                Reset-PSKoan -Context 'first'

                Assert-MockCalled Set-Content -Times 1 -Exactly -Scope -It
                Assert-MockCalled Copy-Item -Times 0 -Scope It
            }

            It 'When Name and Context are supplied, updates an existing user file' {
                Reset-PSKoan -Name 'nested reset content' -Context 'first'

                Assert-MockCalled Set-Content -Times 1 -Exactly -Scope -It
                Assert-MockCalled Copy-Item -Times 0 -Scope It
            }

            It 'When Name and Context are not supplied, copies a koan file from the module' {
                Reset-PSKoan

                Assert-MockCalled Set-Content -Times 0 -Scope -It
                Assert-MockCalled Copy-Item -Times 1 -Exactly -Scope It
            }

            It 'When '
        }

        Context 'User file exists, It block does not exist' {
            Mock Get-KoanIt
            Mock Test-Path { $true }

            It 'When the user file does not include the specified Koan, writes a non-terminating error' {
                { Reset-PSKoan -ErrorAction Stop } | Should -Throw -ErrorId PSKoans.NoMatchingKoanItFound
            }
        }

        Context 'User file does not exist' {
            BeforeAll {
                Mock Test-Path { $false }
            }

            It 'When the user file does not exist, writes an error' {
                { Reset-PSKoan -ErrorAction Stop } | Should -Throw -ErrorId PSKoans.NoMatchingKoanTopicFound
            }
        }

        Context 'Practical tests' {
            BeforeEach {
                Set-Content -Path (Get-PSKoanFile).UserFilePath -Value @'
                    Describe 'AboutSomething' {
                        It 'existing content' {
                            1 | Should -Be 1
                        }

                        It 'reset content' {
                            1 | Should -Be 2
                        }

                        Context 'first' {
                            It 'nested reset content' {
                                3 | Should -Be 3
                            }
                        }

                        Context 'second' {
                            It 'nested reset content' {
                                4 | Should -Be 4
                            }
                        }
                    }
'@
            }

            It 'should reset all koans in a file when Name is not specified' {
                $userFilePath | Should -FileContentMatch '__ | Should -Be 1'
                $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
                $userFilePath | Should -FileContentMatch '__ | Should -Be 3'
                $userFilePath | Should -FileContentMatch '__ | Should -Be 4'
            }

            It 'should reset the state of a single koan without affecting others when Name is specified' {
                Reset-PSKoan -Topic AboutSomething -Name 'reset content' -Confirm:$false

                $userFilePath | Should -FileContentMatch '1 | Should -Be 1'
                $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
            }

            It 'supports context based searching' {
                Reset-PSKoan -Topic AboutSomething -Name "nested reset content" -Context 'first' -Confirm:$false

                $userFilePath | Should -FileContentMatch '__ | Should -Be 3'
                $userFilePath | Should -FileContentMatch '4 | Should -Be 4'
            }

            It 'allows koans of a given name to be reset across all contexts' {
                Reset-PSKoan -Topic AboutSomething -Name "nested reset content" -Confirm:$false

                $userFilePath | Should -FileContentMatch '__ | Should -Be 3'
                $userFilePath | Should -FileContentMatch '__ | Should -Be 4'
            }

            It 'supports wildcard patterns when matching name' {
                Reset-PSKoan -Topic AboutSomething -Name "*content" -Confirm:$false

                $userFilePath | Should -FileContentMatch '__ | Should -Be 1'
                $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
            }
        }
    }
}
