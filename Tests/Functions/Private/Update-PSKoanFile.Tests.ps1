#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Update-PSKoanFile' {
        BeforeAll {
            Mock Get-PSKoanFile {
                [PSCustomObject]@{
                    UserFilePath   = Join-Path $TestDrive 'Koans\AboutSomething.ps1'
                    ModuleFilePath = Join-Path $TestDrive 'Module\AboutSomething.ps1'
                }
            }
            New-Item -Path (Join-Path $TestDrive 'Koans') -ItemType Directory
            New-Item -Path (Join-Path $TestDrive 'Module') -ItemType Directory

            Set-Content -Path (Get-PSKoanFile).ModuleFilePath -Value @'
                Describe 'AboutSomething' {
                    It 'koan 1' {
                        __ | Should -Be 1
                    }

                    It 'koan 2' {
                        __ | Should -Be 2
                    }

                    Context 'first' {
                        It 'koan 3' {
                            __ | Should -Be 3
                        }
                    }

                    Context 'second' {
                        It 'koan 4' {
                            __ | Should -Be 4
                        }
                    }
                }
'@

            $userFilePath = (Get-PSKoanFile).UserFilePath
        }

        BeforeEach {
            Set-Content -Path $userFilePath -Value @'
                Describe 'AboutSomething' {
                    It 'koan 1' {
                        1 | Should -Be 1
                    }

                    It 'koan 2' {
                        __ | Should -Be 2
                    }

                    Context 'second' {
                        It 'koan 4' {
                            4 | Should -Be 4
                        }
                    }
                }
'@
        }

        It 'should replay completed koans' {
            Update-PSKoanFile -Topic AboutSomething -Confirm:$false

            $userFilePath | Should -FileContentMatch '1 | Should -Be 1'
            $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
            $userFilePath | Should -FileContentMatch '4 | Should -Be 4'
        }

        It 'should should allow new koans to be inserted' {
            Update-PSKoanFile -Topic AboutSomething -Confirm:$false

            $userFilePath | Should -FileContentMatch 'koan 3'
        }
    }
}
