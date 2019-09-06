#Requires -Modules PSKoans

Describe 'Get-Karma' {

    InModuleScope 'PSKoans' {

        Context 'Default Behaviour' {
            BeforeAll {
                Mock Invoke-Koan -ModuleName 'PSKoans' { }

                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Update-PSKoan -Confirm:$false
            }

            It 'should produce a hashtable with data' {
                $Result = Get-Karma
                $Result | Should -BeOfType [hashtable]
                $Result.KoansPassed | Should -Be 0
                $Result.Values | Should -Not -BeNullOrEmpty
                $ExpectedKeys = @(
                    'CurrentTopic'
                    'DescribeName'
                    'Expectation'
                    'ItName'
                    'KoansPassed'
                    'Meditation'
                    'Results'
                    'TotalKoans'
                )
                $Result.Keys | Sort-Object | Should -Be $ExpectedKeys
            }

            It 'should Invoke-Pester on each of the koans' {
                $ValidKoans = Get-PSKoanFile

                Assert-MockCalled Invoke-Koan -Times ($ValidKoans.Count)
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
                { Get-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
            }

            It 'should display only the greeting prompt' {
                Assert-MockCalled Show-MeditationPrompt -Times 1
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
                Mock Get-PSKoanFile { }
            }

            It 'should list all the koan topics' {
                Get-Karma -ListTopics
                Assert-MockCalled Get-PSKoanFile
            }
        }

        Context 'With -Topic Parameter' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Invoke-Koan -ModuleName 'PSKoans' { }

                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Update-PSKoan -Confirm:$false

                $TestCases = @(
                    @{ Topic = @( 'AboutAssertions' ) }
                    @{ Topic = @( 'AboutArrays', 'AboutConditionals', 'AboutComparison' ) }
                )
            }

            It 'should Invoke-Pester on only the topics selected: <Topic>' -TestCases $TestCases {
                param([string[]] $Topic)

                Get-Karma -Topic $Topic
                Assert-MockCalled Invoke-Koan -Times @($Topic).Count
            }

            It 'should not divide by zero if all Koans are completed' {
                $KoansCompletedTestLocation = 'TestDrive:{0}PSKoansCompletedTest' -f [System.IO.Path]::DirectorySeparatorChar
                $TestFile = Join-Path -Path $KoansCompletedTestLocation -ChildPath 'SingleTopicTest.Koans.Ps1'

                New-Item $KoansCompletedTestLocation -ItemType Directory
                New-Item $TestFile -ItemType File

                @'
using module PSKoans
[Koan(Position = 1)]
param()

Describe 'Koans Test' {
    It 'is easy to solve' {
        $true | should -be $true
    }
}
'@ | Set-Content $TestFile

                Set-PSKoanLocation $KoansCompletedTestLocation

                { Get-Karma -Topic SingleTopicTest } | Should -Not -Throw

                Set-PSKoanLocation $TestLocation
            }
        }

        Context 'With -Contemplate Switch' {

            Context 'VS Code Installed' {
                BeforeAll {
                    Mock Get-Command { $true }
                    Mock Start-Process { $FilePath }
                }

                It 'should start VS Code with Start-Process' {
                    Get-Karma -Contemplate | Should -Be 'code'

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
                    Get-Karma -Meditate | Should -BeNullOrEmpty
                }
                It 'should open the koans directory with Invoke-Item' {
                    Assert-MockCalled Get-Command -Times 1
                    Assert-MockCalled Invoke-Item -Times 1
                }
            }
        }
    }
}
