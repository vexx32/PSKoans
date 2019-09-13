#Requires -Modules PSKoans

Describe 'Show-Karma' {

    InModuleScope 'PSKoans' {

        Context 'Default Behaviour' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Get-Karma -ModuleName 'PSKoans' {
                    [PSCustomObject]@{
                        PSTypeName   = 'PSKoans.Result'
                        Meditation   = 'TestMeditation'
                        KoansPassed  = 0
                        TotalKoans   = 400
                        Describe     = 'TestDescribe'
                        Expectation  = 'ExpectedTest'
                        It           = 'TestIt'
                        CurrentTopic = [PSCustomObject]@{
                            Name      = 'TestTopic"'
                            Completed = 0
                            Total     = 4
                        }
                    }
                }
            }

            It 'should not produce output' {
                Show-Karma | Should -BeNullOrEmpty
            }

            It 'should write the meditation prompts' {
                Assert-MockCalled Show-MeditationPrompt -Times 2
            }

            It 'should call Get-Karma to examine the koans' {
                Assert-MockCalled Get-Karma
            }
        }

        Context 'With -ClearScreen Switch' {
            BeforeAll {
                Mock Clear-Host { }
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Get-Karma -ModuleName 'PSKoans' {
                    [PSCustomObject]@{
                        PSTypeName   = 'PSKoans.Result'
                        Meditation   = 'TestMeditation'
                        KoansPassed  = 0
                        TotalKoans   = 400
                        Describe     = 'TestDescribe'
                        Expectation  = 'ExpectedTest'
                        It           = 'TestIt'
                        CurrentTopic = [PSCustomObject]@{
                            Name      = 'TestTopic"'
                            Completed = 0
                            Total     = 4
                        }
                    }
                }
            }

            It 'should not produce output' {
                Show-Karma -ClearScreen | Should -Be $null
            }

            It 'should clear the screen' {
                Assert-MockCalled Clear-Host -Times 1
            }

            It 'should write the meditation prompts' {
                Assert-MockCalled Show-MeditationPrompt -Times 2
            }

            It 'should Invoke-Pester on each of the koans' {
                Assert-MockCalled Get-Karma
            }
        }

        Context 'With Nonexistent Koans Folder / No Koans Found' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Measure-Koan -ModuleName 'PSKoans' { }
                Mock Get-Koan -ModuleName 'PSKoans' { }
                Mock Update-PSKoan -ModuleName 'PSKoans' { throw 'Prevent recursion' }
                Mock Write-Warning
            }

            It 'should attempt to populate koans and then recurse to reassess' {
                { Show-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
            }

            It 'should display only the greeting prompt' {
                Assert-MockCalled Show-MeditationPrompt -Times 1
            }

            It 'should display a warning before initiating a reset' {
                Assert-MockCalled Write-Warning
            }

            It 'throws an error if a Topic is specified that matches nothing' {
                { Show-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ExpectedMessage 'Could not find any koans'
            }
        }

        Context 'With -ListTopics Parameter' {
            BeforeAll {
                Mock Get-PSKoanFile { }
            }

            It 'should list all the koan topics' {
                Show-Karma -ListTopics
                Assert-MockCalled Get-PSKoanFile
            }
        }

        Context 'With -Topic Parameter' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Get-Karma -MockWith {
                    [PSCustomObject]@{
                        PSTypeName     = 'PSKoans.Result'
                        Meditation     = 'TestMeditation'
                        KoansPassed    = 0
                        TotalKoans     = 400
                        Describe       = 'TestDescribe'
                        Expectation    = 'ExpectedTest'
                        It             = 'TestIt'
                        CurrentTopic   = [PSCustomObject]@{
                            Name      = 'TestTopic"'
                            Completed = 0
                            Total     = 4
                        }
                        RequestedTopic = $Topic
                    }
                } -ParameterFilter { $Topic }
            }

            It 'should call Get-Karma on the selected topic' {
                Show-Karma -Topic TestTopic
                Assert-MockCalled Get-Karma -ParameterFilter { $Topic -eq "TestTopic" }
            }
        }

        Context 'With -Module Parameter' {


        }

        Context 'With -Contemplate Switch' {

            Context 'VS Code Installed' {
                BeforeAll {
                    Mock Get-Command { $true }
                    Mock Start-Process { $FilePath }
                }

                It 'should start VS Code with Start-Process' {
                    Show-Karma -Contemplate | Should -Be 'code'

                    Assert-MockCalled Get-Command -Times 1
                    Assert-MockCalled Start-Process -Times 1
                }
            }

            Context 'VS Code Not Installed' {
                BeforeAll {
                    Mock Get-Command { $false }
                    Mock Invoke-Item
                }

                It 'should not produce output' {
                    Show-Karma -Meditate | Should -BeNullOrEmpty
                }
                It 'should open the koans directory with Invoke-Item' {
                    Assert-MockCalled Get-Command -Times 1
                    Assert-MockCalled Invoke-Item -Times 1
                }
            }
        }
    }
}
