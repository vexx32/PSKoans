#Requires -Modules PSKoans

Describe 'Get-Karma' {

    InModuleScope 'PSKoans' {

        Context 'Default Behaviour' {
            BeforeAll {
                Mock Invoke-Koan -ModuleName 'PSKoans' {
                    [PSCustomObject]@{
                        PassedCount = 0
                        FailedCount = 4
                    }
                }

                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Update-PSKoan -Confirm:$false
            }

            It 'should produce a hashtable with data' {
                $Result = Get-Karma
                $Result.PSTypeNames[0] | Should -Be 'PSKoans.Result'
                $Result.KoansPassed | Should -Be 0
            }

            It 'should Invoke-Pester on koans until it fails a test' {
                $ValidKoans = Get-PSKoanFile

                Assert-MockCalled Invoke-Koan -Times 1
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

            Describe 'Behaviour When All Koans Are Completed' {
                BeforeAll {
                    $StartLocation = Get-PSKoanLocation
                    Set-PSKoanLocation -Path "$PSScriptRoot/CompletedKoan"

                    $Result = Get-Karma -Topic SelectedTopicTest
                }

                It 'should output the result object' {
                    $Result | Should -Not -BeNullOrEmpty
                    $Result.PSTypeNames | Should -Contain 'PSKoans.CompleteResult'
                }

                It 'should indicate completion' {
                    $Result.Complete | Should -BeTrue
                }

                It 'should indicate number of koans passed' {
                    $Result.KoansPassed | Should -Be 1
                }

                It 'should indicate total number of koans' {
                    $Result.TotalKoans | Should -Be 2
                }

                It 'should indicate the requested topic' {
                    $Result.RequestedTopic | Should -Be 'SelectedTopicTest'
                }

                Set-PSKoanLocation -Path $StartLocation
            }
        }
    }
}
