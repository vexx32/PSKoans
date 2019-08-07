#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Update-PSKoanFile' {
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
                "    It 'koan 1' {"
                "        __ | Should -Be 1"
                "    }"

                "    It 'koan 2' {"
                "        __ | Should -Be 2"
                "    }"

                "    Context 'first' {"
                "        It 'koan 3' {"
                "            __ | Should -Be 3"
                "        }"
                "    }"

                "    Context 'second' {"
                "        It 'koan 4' {"
                "            __ | Should -Be 4"
                "        }"
                "    }"
                "}"
            )
        }

        BeforeEach {
            Set-Content -Path (Get-PSKoanFilePath).UserFilePath -Value @(
                "Describe 'AboutSomething' {"
                "    It 'koan 1' {"
                "        1 | Should -Be 1"
                "    }"

                "    It 'koan 2' {"
                "        __ | Should -Be 2"
                "    }"

                "    Context 'second' {"
                "        It 'koan 4' {"
                "            4 | Should -Be 4"
                "        }"
                "    }"
                "}"
            )
        }

        It 'should replay completed koans' {
            Update-PSKoanFile -Topic AboutSomething -Confirm:$false

            (Get-PSKoanFilePath).UserFilePath | Should -FileContentMatch '1 | Should -Be 1'
            (Get-PSKoanFilePath).UserFilePath | Should -FileContentMatch '__ | Should -Be 2'
            (Get-PSKoanFilePath).UserFilePath | Should -FileContentMatch '4 | Should -Be 4'
        }

        It 'should should allow new koans to be inserted' {
            Update-PSKoanFile -Topic AboutSomething -Confirm:$false

            (Get-PSKoanFilePath).UserFilePath | Should -FileContentMatch 'koan 3'
        }
    }
}
