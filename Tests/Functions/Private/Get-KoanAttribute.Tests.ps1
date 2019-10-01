#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

InModuleScope PSKoans {
    Describe Get-KoanAttribute {
        BeforeAll {
            $defaultParams = @{
                Path = Join-Path $TestDrive 'AboutSomething.Koans.ps1'
            }
        }

        Context 'Content has no errors' {
            BeforeAll {
                Mock Get-KoanAst {
                    {
                        [Koan(Position = 1)]
                        param( )

                        Describe 'About something' {
                            It 'Has examples' {
                                $true | Should -BeTrue
                            }
                        }
                    }.Ast
                }
            }

            It 'Gets the position argument from the Koan attribute'  {
                $attributeInfo = Get-KoanAttribute @defaultParams

                $attributeInfo | Should -Not -BeNullOrEmpty
                $attributeInfo.Position | Should -Be 1
            }

            It 'When Module is not set, uses a default value for Module' {
                $attributeInfo = Get-KoanAttribute @defaultParams

                $attributeInfo | Should -Not -BeNullOrEmpty
                $attributeInfo.Module | Should -Be ([KoanAttribute]::new().Module)
            }
        }

        Context 'Module declared' {
            BeforeAll {
                Mock Get-KoanAst {
                    {
                        [Koan(Position = 1, Module = 'Name')]
                        param( )

                        Describe 'About something' {
                            It 'Has examples' {
                                $true | Should -BeTrue
                            }
                        }
                    }.Ast
                }
            }

            It 'When Module is set, retrieves the value for the module' {
                $attributeInfo = Get-KoanAttribute @defaultParams

                $attributeInfo | Should -Not -BeNullOrEmpty
                $attributeInfo.Position | Should -Be 1
                $attributeInfo.Module | Should -Be 'Name'
            }
        }

        Context 'Full attribute name used' {
            BeforeAll {
                Mock Get-KoanAst {
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

            It 'Returns attribute information the full name is used'  {
                $attributeInfo = Get-KoanAttribute @defaultParams

                $attributeInfo | Should -Not -BeNullOrEmpty
                $attributeInfo.Position | Should -Be 1
            }
        }

        Context 'Content has errors' {
            BeforeAll {
                Set-Content @defaultParams -Value @'
                    [Koan(Position = 1)]
                    param( )

                    Describe 'About something' {
                        It 'Has examples' {
                            -not ____ | Should -BeTrue
                        }
                    }
'@
            }

            It 'Retrieves the Koan attribute if the file has syntax errors' {
                $attributeInfo = Get-KoanAttribute @defaultParams

                $attributeInfo | Should -Not -BeNullOrEmpty
                $attributeInfo.Position | Should -Be 1
            }
        }

        Context 'Attribute is missing' {
            BeforeAll {
                Mock Get-KoanAst {
                    {
                        param( )

                        Describe 'About something' {
                            It 'Has examples' {
                                $true | Should -BeTrue
                            }
                        }
                    }.Ast
                }
            }

            It 'When the Koan attribute is missing, returns nothing' {
                $attributeInfo = Get-KoanAttribute @defaultParams

                $attributeInfo | Should -BeNullOrEmpty
            }
        }
    }
}
