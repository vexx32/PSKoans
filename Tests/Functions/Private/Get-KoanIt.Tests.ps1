#Requires -Modules PSKoans

Describe 'Get-KoanIt' {

    BeforeAll {
        $defaultParams = @{
            Path = Join-Path $TestDrive 'AboutSomething.Koans.ps1'
        }
    }

    Context 'Content has no errors' {

        BeforeAll {
            Mock 'Get-KoanAst' -ModuleName 'PSKoans' {
                {
                    [Koan(Position = 1)]
                    param( )

                    Describe 'About something' {
                        It 'first' {
                            $true | Should -BeTrue
                        }

                        It 'second' {
                            $true | Should -BeTrue
                        }
                    }
                }.Ast
            }
        }

        It 'returns all information about all It blocks' {
            $ItCommands = InModuleScope 'PSKoans' -Parameters $defaultParams {
                param($Path)
                Get-KoanIt $Path
            }

            $ItCommands | Should -Not -BeNullOrEmpty
            $ItCommands.Count | Should -Be 2
        }
    }

    Context 'Content has errors' {

        BeforeAll {
            Set-Content @defaultParams -Value @'
                    [Koan(Position = 1)]
                    param( )

                    Describe 'About something' {
                        It 'first' {
                            -not ____ | Should -BeTrue
                        }

                        It 'second' {
                            $true | Should -BeTrue
                        }
                    }
'@
        }

        It 'Retrieves all It blocks when the file has syntax errors' {
            $ItCommands = InModuleScope 'PSKoans' -Parameters $defaultParams {
                param($Path)
                Get-KoanIt $Path
            }

            $ItCommands | Should -Not -BeNullOrEmpty
            $ItCommands.Count | Should -Be 2
        }
    }
}
