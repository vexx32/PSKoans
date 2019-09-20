#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

InModuleScope 'PSKoans' {
    Describe 'Get-Karma' {
        BeforeAll {
            $TestLocation = Join-Path -Path $TestDrive -ChildPath 'PSKoans'

            Mock Get-PSKoanLocation {
                $TestLocation
            }

            Update-PSKoan -Confirm:$false
        }

        Context 'Default Behaviour' {
            BeforeAll {
                Mock Invoke-Koan -ModuleName 'PSKoans' {
                    [PSCustomObject]@{
                        PassedCount = 0
                        FailedCount = 4
                    }
                }
            }

            It 'should produce a hashtable with data' {
                $Result = Get-Karma
                $Result.PSTypeNames[0] | Should -Be 'PSKoans.Result'
                $Result.KoansPassed | Should -Be 0
            }

            It 'should Invoke-Pester on koans until it fails a test' {
                Assert-MockCalled Invoke-Koan -Times 1
            }
        }

        Context 'With Nonexistent Koans Folder / No Koans Found' {
            BeforeAll {
                Mock Measure-Koan -ModuleName 'PSKoans' { }
                Mock Update-PSKoan -ModuleName 'PSKoans' { throw 'Prevent recursion' }
                Mock Write-Warning
            }

            It 'should attempt to populate koans and then recurse to reassess' {
                { Get-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
            }

            It 'should display a warning before initiating a reset' {
                Assert-MockCalled Write-Warning
            }

            It 'throws an error if a Topic is specified that matches nothing' {
                { Get-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ExpectedMessage 'Could not find any koans'
            }
        }

        Context 'With -ListTopics Parameter' {
            BeforeAll {
                Mock Get-PSKoan { }
            }

            It 'should list all the koan topics' {
                Get-Karma -ListTopics

                Assert-MockCalled Get-PSKoan
            }
        }

        Context 'With -Topic Parameter' {
            BeforeAll {
                Mock Invoke-Koan -ModuleName 'PSKoans' { }
            }

            It 'should Invoke-Pester on only the topics selected: <Topic>' -TestCases @(
                @{ Topic = @( 'AboutAssertions' ) }
                @{ Topic = @( 'AboutArrays', 'AboutConditionals', 'AboutComparison' ) }
            ) {
                param([string[]] $Topic)

                Get-Karma -Topic $Topic

                Assert-MockCalled Invoke-Koan -Times @($Topic).Count
            }
        }

        Context 'Behaviour When All Koans Are Completed' {
            BeforeAll {
                Mock Get-PSKoanLocation {
                    Join-Path -Path $TestDrive -ChildPath 'CompletedKoan'
                }

                $TestFile = Join-Path -Path (Get-PSKoanLocation) -ChildPath 'Group\SelectedTopicTest.Koans.Ps1'
                New-Item -Path (Split-Path $TestFile -Parent) -ItemType Directory -Force
                Set-Content -Path $TestFile -Value @'
                    using module PSKoans
                    [Koan(Position = 1)]
                    param()

                    Describe 'Koans Test' {

                        It 'is easy to solve' {
                            $true | Should -BeTrue
                        }

                        It 'is positively trivial' {
                            $false | Should -BeFalse
                        }
                    }
'@

                try {
                    $Result = Get-Karma -Topic SelectedTopicTest
                } catch {
                    # Ignore this. Error tests follow.
                }
            }

            It 'should not divide by zero if all Koans are completed' {
                { Get-Karma -Topic SelectedTopicTest } | Should -Not -Throw
            }

            It 'should output the result object' {
                $Result | Should -Not -BeNullOrEmpty
                $Result.PSTypeNames | Should -Contain 'PSKoans.CompleteResult'
            }

            It 'should indicate completion' {
                $Result.Complete | Should -BeTrue
            }

            It 'should indicate number of koans passed' {
                $Result.KoansPassed | Should -Be 2
            }

            It 'should indicate total number of koans' {
                $Result.TotalKoans | Should -Be 2
            }

            It 'should indicate the requested topic' {
                $Result.RequestedTopic | Should -Be 'SelectedTopicTest'
            }
        }
    }
}
