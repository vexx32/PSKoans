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
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
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
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
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

        Context 'All koans completed' {
            BeforeAll {
                Mock Get-PSKoanLocation {
                    Join-Path -Path $TestDrive -ChildPath 'PSKoansCompletedTest'
                }
            }

            It 'should not divide by zero if all Koans are completed' {
                $TestFile = Join-Path -Path (Get-PSKoanLocation) -ChildPath 'Group\SingleTopicTest.Koans.Ps1'

                New-Item -Path (Split-Path $TestFile -Parent) -ItemType Directory -Force
                Set-Content -Path $TestFile -Value @'
using module PSKoans
[Koan(Position = 1)]
param()

Describe 'Koans Test' {
    It 'is easy to solve' {
        $true | should -be $true
    }
}
'@

                { Get-Karma -Topic SingleTopicTest } | Should -Not -Throw
            }
        }
    }
}
