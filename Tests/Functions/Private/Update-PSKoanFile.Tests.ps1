#Requires -Modules PSKoans

Describe 'Update-PSKoanFile' {

    BeforeAll {
        Mock 'Get-PSKoanLocation' {
            Join-Path -Path $TestDrive -ChildPath 'Koans'
        }

        Mock 'Get-PSKoan' {
            [PSCustomObject]@{
                Topic        = 'AboutSomething'
                Path         = Join-Path -Path $TestDrive -ChildPath 'Module/Group/AboutSomething.ps1'
                RelativePath = 'Group/AboutSomething.ps1'
            }
        }

        New-Item -Path (Join-Path -Path $TestDrive -ChildPath 'Koans/Group') -ItemType Directory
        New-Item -Path (Join-Path -Path $TestDrive -ChildPath 'Module/Group') -ItemType Directory

        Set-Content -Path (Get-PSKoan).Path -Value @'
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

        $userFilePath = Join-Path -Path (Get-PSKoanLocation) -ChildPath (Get-PSKoan).RelativePath
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
        InModuleScope 'PSKoans' { Update-PSKoanFile -Topic AboutSomething -Confirm:$false }

        $userFilePath | Should -FileContentMatch '1 | Should -Be 1'
        $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
        $userFilePath | Should -FileContentMatch '4 | Should -Be 4'
    }

    It 'should should allow new koans to be inserted' {
        InModuleScope 'PSKoans' { Update-PSKoanFile -Topic AboutSomething -Confirm:$false }

        $userFilePath | Should -FileContentMatch 'koan 3'
    }
}
