#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Reset-PSKoan' {
        BeforeAll {
            Mock Get-PSKoanFilePath {
                [PSCustomObject]@{
                    UserFilePath   = Join-Path $TestDrive 'Koans\AboutSomething.ps1'
                    ModuleFilePath = Join-Path $TestDrive 'Module\AboutSomething.ps1'
                }
            }
            New-Item (Join-Path $TestDrive 'Koans') -ItemType Directory
            New-Item (Join-Path $TestDrive 'Module') -ItemType Directory

            Set-Content -Path (Get-PSKoanFilePath).ModuleFilePath -Value @(
                "Describe 'AboutSomething' {"
                "    It 'existing content' {"
                "        __ | Should -Be 1"
                "    }"

                "    It 'reset content' {"
                "        __ | Should -Be 2"
                "    }"

                "    Context 'first' {"
                "        It 'nested reset content' {"
                "            __ | Should -Be 3"
                "        }"
                "    }"

                "    Context 'second' {"
                "        It 'nested reset content' {"
                "            __ | Should -Be 4"
                "        }"
                "    }"
                "}"
            )

            $userFilePath = (Get-PSKoanFilePath).UserFilePath
        }

        BeforeEach {
            Set-Content -Path (Get-PSKoanFilePath).UserFilePath -Value @(
                "Describe 'AboutSomething' {"
                "    It 'existing content' {"
                "        1 | Should -Be 1"
                "    }"

                "    It 'reset content' {"
                "        1 | Should -Be 2"
                "    }"

                "    Context 'first' {"
                "        It 'nested reset content' {"
                "            3 | Should -Be 3"
                "        }"
                "    }"

                "    Context 'second' {"
                "        It 'nested reset content' {"
                "            4 | Should -Be 4"
                "        }"
                "    }"
                "}"
            )
        }

        It 'should reset the state of a single koan without affecting others' {
            Reset-PSKoan -Topic AboutSomething -Name 'reset content' -Confirm:$false

            $userFilePath | Should -FileContentMatch '1 | Should -Be 1'
            $userFilePath | Should -FileContentMatch '__ | Should -Be 2'
        }

        It 'supports wildcard matching for name' {
            Reset-PSKoan -Topic AboutSomething -Name "*content" -Confirm:$false

            $userFilePath | Should -FileContentMatch '__ | Should -Be 1'
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
    }
}
