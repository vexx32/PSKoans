#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

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

        Context 'With All Koans Completed' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { $Complete }
                Mock Get-Karma -ModuleName 'PSKoans' {
                    [PSCustomObject]@{
                        PSTypeName     = 'PSKoans.CompleteResult'
                        KoansPassed    = 10
                        TotalKoans     = 10
                        RequestedTopci = $null
                        Complete       = $true
                    }
                }
            }

            It 'should not throw errors' {
                { Show-Karma } | Should -Not -Throw
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
                Mock Get-PSKoan -ModuleName 'PSKoans' { }
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
                { Show-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ErrorId 'PSKoans.TopicNotFound'
            }
        }

        Context 'With -ListTopics Parameter' {
            BeforeAll {
                Mock Get-PSKoan
            }

            It 'should list all the koan topics' {
                Show-Karma -ListTopics
                Assert-MockCalled Get-PSKoan
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

        Context 'With All Koans in a Single Topic Completed' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { $Complete }
                Mock Get-Karma -ModuleName 'PSKoans' {
                    [PSCustomObject]@{
                        PSTypeName     = 'PSKoans.CompleteResult'
                        KoansPassed    = 10
                        TotalKoans     = 10
                        RequestedTopic = 'TestTopic'
                        Complete       = $true
                    }
                }
            }

            It 'should not throw errors' {
                { Show-Karma } | Should -Not -Throw
            }
        }

        Context 'With -Meditate Switch' {

            Context 'With "code" Set as the Editor' {
                BeforeAll {
                    Mock Get-Command { $true }
                    Mock Start-Process {
                        @{ Editor = $FilePath; Path = $ArgumentList }
                    }
                    Set-PSKoanSetting -Name Editor -Value 'code'

                    $Result = Show-Karma -Contemplate
                }

                It 'should start VS Code with Start-Process' {
                    $Result.Editor | Should -Be 'code'

                    Assert-MockCalled Get-Command -Times 1
                    Assert-MockCalled Start-Process -Times 1
                }

                It 'should pass a resolved path using quotes' {
                    $Result.Path | Should -MatchExactly '"[^"]+"'

                    # Resolve-Path doesn't like embedded quotes
                    $Path = $Result.Path -replace '"'
                    $Path | Should -BeExactly (Resolve-Path -Path $Path).Path
                }
            }

            Context 'With Editor Not Found' {
                BeforeAll {
                    Mock Get-Command { $false }
                    Mock Invoke-Item
                    Set-PSKoanSetting -Name Editor -Value "ascsadsa"
                }

                It 'should not produce output' {
                    Show-Karma -Meditate | Should -BeNullOrEmpty
                }

                It 'should open the koans directory with Invoke-Item' {
                    Assert-MockCalled Get-Command -Times 1 -ParameterFilter { $Name -eq "ascsadsa" }
                    Assert-MockCalled Invoke-Item -Times 1
                }
            }

            Context 'With Nonexistent KoanLocation' {
                BeforeAll {
                    Mock Test-Path { $false }
                    Mock Update-PSKoan
                    Mock Get-Command { $false }
                    Mock Invoke-Item
                    Mock New-Item
                }

                It 'should create PSKoans directory' {
                    Show-Karma -Meditate

                    Assert-MockCalled Test-Path -Times 1
                    Assert-MockCalled Update-PSKoan -Times 1
                    Assert-MockCalled Get-Command -Times 1
                    Assert-MockCalled New-Item -Times 1
                    Assert-MockCalled Invoke-Item -Times 1
                }
            }
        }
    }
}
