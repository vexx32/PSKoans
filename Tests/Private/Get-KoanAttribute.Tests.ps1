#Requires -Modules PSKoans

Describe 'Get-KoanAttribute' {

    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
        $filePath = @{
            Path = Join-Path $TestDrive  -ChildPath 'AboutSomething.Koans.ps1'
        }
    }

    Context 'Content has no errors' {

        BeforeAll {
            Mock 'Get-KoanAst' @module {
                {
                    [Koan(Position = 1)]
                    param()

                    Describe 'About something' {

                        It 'Has examples' {
                            $true | Should -BeTrue
                        }
                    }
                }.Ast
            }
        }

        It 'gets the position argument from the Koan attribute' {
            $attributeInfo = InModuleScope 'PSKoans' -Parameters $filePath {
                param($Path)
                Get-KoanAttribute $Path
            }

            $attributeInfo | Should -Not -BeNullOrEmpty
            $attributeInfo.Position | Should -Be 1
        }

        It 'uses a default value for Module when it is not set' {
            $attributeInfo = InModuleScope 'PSKoans' -Parameters $filePath {
                param($Path)
                Get-KoanAttribute $Path
            }

            $attributeInfo | Should -Not -BeNullOrEmpty
            $attributeInfo.Module | Should -Be ([KoanAttribute]::new().Module)
        }
    }

    Context 'Module declared' {

        BeforeAll {
            Mock 'Get-KoanAst' @module {
                {
                    [Koan(Position = 1, Module = 'Name')]
                    param()

                    Describe 'About something' {

                        It 'has examples' {
                            $true | Should -BeTrue
                        }
                    }
                }.Ast
            }
        }

        It 'retrieves the value for the module when it is set' {
            $attributeInfo = InModuleScope 'PSKoans' -Parameters $filePath {
                param($Path)
                Get-KoanAttribute $Path
            }

            $attributeInfo | Should -Not -BeNullOrEmpty
            $attributeInfo.Position | Should -Be 1
            $attributeInfo.Module | Should -Be 'Name'
        }
    }

    Context 'Full attribute name used' {

        BeforeAll {
            Mock 'Get-KoanAst' @module {
                {
                    [KoanAttribute(Position = 1)]
                    param( )

                    Describe 'About something' {
                        It 'Has examples' {
                            $true | Should -BeTrue
                        }
                    }
                }.Ast
            }
        }

        It 'still returns attribute information when the full name is used' {
            $attributeInfo = InModuleScope 'PSKoans' -Parameters $filePath {
                param($Path)
                Get-KoanAttribute $Path
            }

            $attributeInfo | Should -Not -BeNullOrEmpty
            $attributeInfo.Position | Should -Be 1
        }
    }

    Context 'Content has errors' {

        BeforeAll {
            Set-Content @filePath -Value @'
                [Koan(Position = 1)]
                param()

                Describe 'About something' {
                    It 'has examples' {
                        -not ____ | Should -BeTrue
                    }
                }
'@
        }

        It 'retrieves the Koan attribute even if the file has syntax errors' {
            $attributeInfo = InModuleScope 'PSKoans' -Parameters $filePath {
                param($Path)
                Get-KoanAttribute $Path
            }

            $attributeInfo | Should -Not -BeNullOrEmpty
            $attributeInfo.Position | Should -Be 1
        }
    }

    Context 'Attribute is missing' {

        BeforeAll {
            Mock 'Get-KoanAst' @module {
                {
                    param()

                    Describe 'About something' {
                        It 'Has examples' {
                            $true | Should -BeTrue
                        }
                    }
                }.Ast
            }
        }

        It 'When the Koan attribute is missing, returns nothing' {
            $attributeInfo = InModuleScope 'PSKoans' -Parameters $filePath {
                param($Path)
                Get-KoanAttribute $Path
            }

            $attributeInfo | Should -BeNullOrEmpty
        }
    }
}
