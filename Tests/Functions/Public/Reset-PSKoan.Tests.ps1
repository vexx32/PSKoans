#Requires -Modules PSKoans

Describe Reset-PSKoan {

    BeforeAll {
        $defaultParams = @{
            Confirm = $false
        }

        Mock 'Get-PSKoanLocation' {
            Join-Path -Path $TestDrive -ChildPath 'PSKoans'
        }

        Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'Module' } -MockWith {
            [PSCustomObject]@{
                Topic        = 'AboutSomething'
                Path         = Join-Path -Path $TestDrive -ChildPath 'Module\Group\AboutSomething.Koans.ps1'
                RelativePath = 'Group\AboutSomething.Koans.ps1'
            }
        }

        New-Item -Path (Join-Path -Path $TestDrive -ChildPath 'Module\Group') -ItemType Directory
        New-Item -Path (Join-Path -Path $TestDrive -ChildPath 'PSKoans\Group') -ItemType Directory

        $userFilePath = Get-PSKoanLocation | Join-Path -ChildPath 'Group\AboutSomething.Koans.ps1'

        Set-Content -Path (Get-PSKoan -Scope Module).Path, $userFilePath -Value @'
            using module PSKoans
            [Koan(Position = 1)]
            param ( )

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
    }

    Context 'User file exists, It block exists' {

        BeforeAll {
            Mock 'Set-Content'
            Mock 'Copy-Item'
        }

        It 'updates an existing user file when -Name is supplied' {
            Reset-PSKoan -Name 'existing content' @defaultParams

            Should -Invoke 'Set-Content' -Times 1
            Should -Invoke 'Copy-Item' -Times 0
        }

        It 'updates an existing user file when -Context is supplied' {
            Reset-PSKoan -Context 'first' @defaultParams

            Should -Invoke 'Set-Content' -Times 1 -Exactly
            Should -Invoke 'Copy-Item' -Times 0
        }

        It 'updates an existing user file when -Name and -Context are supplied' {
            Reset-PSKoan -Name 'nested reset content' -Context 'first' @defaultParams

            Should -Invoke 'Set-Content' -Times 1 -Exactly
            Should -Invoke 'Copy-Item' -Times 0
        }

        It 'copies a koan file from the module when -Name and -Context are not supplied' {
            Reset-PSKoan @defaultParams

            Should -Invoke 'Set-Content' -Times 0
            Should -Invoke 'Copy-Item' -Times 1 -Exactly
        }
    }

    Context 'User file exists, It block does not exist' {

        It 'writes a non-terminating error when the user file does not include the specified Koan' {
            Mock 'Get-KoanIt' -ParameterFilter { $Path -match 'PSKoans' } -Module 'PSKoans'

            { Reset-PSKoan -Topic AboutSomething -Name 'existing content' -ErrorAction Stop @defaultParams } |
                Should -Throw -ErrorId 'PSKoans.UserItNotFound,Reset-PSKoan'
        }
    }

    Context 'User file does not exist' {

        BeforeAll {
            New-Item "$TestDrive/DoesNotExist.Koans.ps1" -ItemType File > $null

            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'User' } -Verifiable
            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'Module' } -Verifiable -MockWith {
                [PSCustomObject]@{
                    Topic        = $Topic
                    Module       = '_powershell'
                    Position     = 101
                    Path         = "$TestDrive/DoesNotExist.Koans.ps1"
                    RelativePath = 'DoesNotExist.Koans.ps1'
                    PSTypeName   = 'PSKoans.KoanInfo'
                }
            }

            Mock 'Update-PSKoan'
        }

        It 'calls Update-PSKoan when the topic does not exist in the user location' {
            Reset-PSKoan -Topic DoesNotExist -ErrorAction Stop @defaultParams

            Should -InvokeVerifiable
            Should -Invoke Update-PSKoan -Times 1 -Exactly
        }
    }

    Context 'Module file does not exist' {

        BeforeAll {
            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'Module' }
        }

        It 'throws a terminating error when no topics are found in the module' {
            { Reset-PSKoan -Topic DoesNotExist @defaultParams } |
                Should -Throw -ErrorId 'PSKoans.ModuleTopicNotFound,Reset-PSKoan'

            Should -Invoke 'Get-PSKoan' -Times 1 -Exactly
        }
    }

    Context 'Practical tests' {

        BeforeEach {
            Set-Content -Path $userFilePath -Value @'
                using module PSKoans
                [Koan(Position = 1)]
                param ( )

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
            Reset-PSKoan -Topic AboutSomething -Name 'reset content' @defaultParams

            $userFilePath | Should -FileContentMatch '1 | Should -Be 1'
            $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
        }

        It 'supports context based searching' {
            Reset-PSKoan -Topic AboutSomething -Name "nested reset content" -Context 'first' @defaultParams

            $userFilePath | Should -FileContentMatch '__ | Should -Be 3'
            $userFilePath | Should -FileContentMatch '4 | Should -Be 4'
        }

        It 'allows koans of a given name to be reset across all contexts' {
            Reset-PSKoan -Topic AboutSomething -Name "nested reset content" @defaultParams

            $userFilePath | Should -FileContentMatch '__ | Should -Be 3'
            $userFilePath | Should -FileContentMatch '__ | Should -Be 4'
        }

        It 'supports wildcard patterns when matching name' {
            Reset-PSKoan -Topic AboutSomething -Name "*content" @defaultParams

            $userFilePath | Should -FileContentMatch '__ | Should -Be 1'
            $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
        }
    }
}
