#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

Describe 'Show-Karma' {
    BeforeAll {
        $StartingLocation = Get-PSKoanLocation
        Set-PSKoanLocation -Path "$TestDrive/Koans"

        $EditorSetting = Get-PSKoanSetting -Name Editor

        Reset-PSKoan -Confirm:$false
    }

    AfterAll {
        Set-PSKoanLocation -Path $StartingLocation
        Set-PSKoanSetting -Name Editor -Value $EditorSetting
    }

    InModuleScope 'PSKoans' {

        Context 'Default Behaviour' {
            BeforeAll {
                Mock Write-Host { }
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
                            Name        = 'TestTopic"'
                            Completed   = 0
                            Total       = 4
                            CurrentLine = 1
                        }
                    }
                }
            }

            It 'should not produce output' {
                Show-Karma | Should -BeNullOrEmpty
            }

            It 'should write the formatted output to host' {
                Assert-MockCalled Write-Host
            }

            It 'should call Get-Karma to examine the koans' {
                Assert-MockCalled Get-Karma
            }
        }

        Context 'With All Koans Completed' {
            BeforeAll {
                Mock Write-Host { }
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
                Mock Write-Host { }
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
                            Name        = 'TestTopic"'
                            Completed   = 0
                            Total       = 4
                            CurrentLine = 1
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

            It 'should display the rendered output' {
                Assert-MockCalled Write-Host
            }

            It 'should Invoke-Pester on each of the koans' {
                Assert-MockCalled Get-Karma
            }
        }

        Context 'With Nonexistent Koans Folder / No Koans Found' {
            BeforeAll {
                Mock Write-Host { }
                Mock Get-PSKoan -ModuleName 'PSKoans' { }
                Mock Update-PSKoan -ModuleName 'PSKoans' { throw 'Prevent recursion' }
                Mock Write-Warning
                Mock Test-Path { $false }
                Mock Invoke-Item
                Mock New-Item
            }

            BeforeEach {
                $script:CurrentTopic = $null
            }

            It 'should attempt to populate koans and then recurse to reassess' {
                { Show-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
            }

            It 'should display a warning before initiating a reset' {
                Assert-MockCalled Write-Warning
            }

            It 'throws an error if a Topic is specified that matches nothing' {
                { Show-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ErrorId 'PSKoans.TopicNotFound'
            }

            It 'should create PSKoans directory with -Library' {
                { Show-Karma -Library } | Should -Throw -ExpectedMessage 'Prevent recursion'

                Assert-MockCalled Test-Path -Times 1
                Assert-MockCalled Update-PSKoan -Times 1
                Assert-MockCalled New-Item -Times 1
            }

            It 'should create PSKoans directory with -Contemplate' {
                { Show-Karma -Contemplate } | Should -Throw -ExpectedMessage 'Prevent recursion'

                Assert-MockCalled Test-Path -Times 1
                Assert-MockCalled Update-PSKoan -Times 1
                Assert-MockCalled New-Item -Times 1
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
                Mock Write-Host { }
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
                            Name        = 'TestTopic"'
                            Completed   = 0
                            Total       = 4
                            CurrentLine = 1
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
                Mock Format-Custom { $InputObject.Complete }
                Mock Write-Host { }
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

        Context 'With -Contemplate Switch' {
            BeforeAll {
                $TestFile = New-TemporaryFile

                Mock Invoke-Item { $Path }
                Mock Get-Command { $true } -ParameterFilter { $Name -ne "missing_editor" }
                Mock Get-Command { $false } -ParameterFilter { $Name -eq "missing_editor" }
                Mock Start-Process {
                    @{ Editor = $FilePath; Arguments = $ArgumentList; NoNewWindow = $NoNewWindow }
                }
                Mock Get-Karma -ModuleName 'PSKoans' {
                    $script:CurrentTopic = @{
                        Name        = 'TestTopic'
                        Completed   = 0
                        Total       = 4
                        CurrentLine = 1
                    }

                    [PSCustomObject]@{
                        PSTypeName   = 'PSKoans.Result'
                        Meditation   = 'TestMeditation'
                        KoansPassed  = 0
                        TotalKoans   = 400
                        Describe     = 'TestDescribe'
                        Expectation  = 'ExpectedTest'
                        It           = 'TestIt'
                        CurrentTopic = [PSCustomObject]$script:CurrentTopic
                    }
                }
                Mock Get-PSKoan -ModuleName 'PSKoans' {
                    [PSCustomObject]@{ Path = $TestFile.FullName }
                } -ParameterFilter { $Topic -eq 'TestTopic' }
            }

            AfterAll {
                $TestFile | Remove-Item
            }

            It 'invokes VS Code with "code" set as Editor with proper arguments' {
                Set-PSKoanSetting -Name Editor -Value 'code'
                $Result = Show-Karma -Contemplate

                $Result.Editor | Should -BeExactly 'code'
                $Result.Arguments[0] | Should -BeExactly '--goto'
                $Result.Arguments[1] | Should -MatchExactly '"[^"]+":\d+'
                $Result.Arguments[2] | Should -BeExactly '--reuse-window'
                $Result.NoNewWindow | Should -BeTrue

                # Resolve-Path doesn't like embedded quotes
                $Path = ($Result.Arguments[1] -split '(?<="):')[0] -replace '"'
                $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Start-Process -Times 1

                $script:CurrentTopic | Should -BeNullOrEmpty
            }

            It 'opens the specified -Topic in the selected editor' {
                Set-PSKoanSetting -Name Editor -Value 'code'
                $Result = Show-Karma -Contemplate -Topic TestTopic

                $Result.Arguments[1] | Should -MatchExactly ([regex]::Escape($TestFile.FullName))

                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Start-Process -Times 1

                $script:CurrentTopic | Should -BeNullOrEmpty
            }

            It 'invokes the set editor with unknown editor chosen' {
                Set-PSKoanSetting -Name Editor -Value 'vim'

                $Result = Show-Karma -Contemplate
                $Result.Editor | Should -BeExactly 'vim'
                $Result.Arguments | Should -MatchExactly '"[^"]+"'

                # Resolve-Path doesn't like embedded quotes
                $Path = $Result.Arguments -replace '"'
                $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Start-Process -Times 1

                $script:CurrentTopic | Should -BeNullOrEmpty
            }

            It 'opens the file directly when selected editor is unavailable' {
                Set-PSKoanSetting -Name Editor -Value "missing_editor"

                Show-Karma -Contemplate | Should -BeExactly $TestFile.FullName

                Assert-MockCalled Get-Command -Times 1 -ParameterFilter { $Name -eq "missing_editor" }
                Assert-MockCalled Invoke-Item -Times 1

                $script:CurrentTopic | Should -BeNullOrEmpty
            }
        }

        Context 'With -Library Switch' {
            BeforeAll {
                Mock Get-Command { $true } -ParameterFilter { $Name -ne "missing_editor" }
                Mock Get-Command { $false } -ParameterFilter { $Name -eq "missing_editor" }
                Mock Start-Process {
                    @{ Editor = $FilePath; Arguments = $ArgumentList }
                }
                Mock Invoke-Item { $Path }
            }

            It 'invokes VS Code with "code" set as Editor with proper arguments' {
                Set-PSKoanSetting -Name Editor -Value 'code'
                $Result = Show-Karma -Library

                $Result.Editor | Should -BeExactly 'code'

                # Resolve-Path doesn't like embedded quotes
                $Path = $Result.Arguments -replace '"'
                $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Start-Process -Times 1
            }

            It 'invokes the set editor with unknown editor chosen' {
                Set-PSKoanSetting -Name Editor -Value 'vim'

                $Result = Show-Karma -Library
                $Result.Editor | Should -BeExactly 'vim'

                # Resolve-Path doesn't like embedded quotes
                $Path = $Result.Arguments -replace '"'
                $Path | Should -BeExactly (Resolve-Path -Path $Path).Path

                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Start-Process -Times 1
            }

            It 'opens the file directly when selected editor is unavailable' {
                Set-PSKoanSetting -Name Editor -Value "missing_editor"

                Show-Karma -Library | Should -BeExactly (Get-PSKoanLocation)

                Assert-MockCalled Get-Command -Times 1 -ParameterFilter { $Name -eq "missing_editor" }
                Assert-MockCalled Invoke-Item -Times 1
            }
        }
    }
}
