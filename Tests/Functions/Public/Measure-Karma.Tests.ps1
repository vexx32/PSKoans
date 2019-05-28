#Requires -Modules PSKoans

Describe 'Measure-Karma' {

    InModuleScope 'PSKoans' {

        Context 'Default Behaviour' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Invoke-Koan -ModuleName 'PSKoans' { }

                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Initialize-KoanDirectory -Confirm:$false
            }

            It 'should not produce output' {
                Measure-Karma | Should -Be $null
            }

            It 'should write the meditation prompts' {
                Assert-MockCalled Show-MeditationPrompt -Times 2
            }

            It 'should Invoke-Pester on each of the koans' {
                $ValidKoans = Get-PSKoanLocation | Get-ChildItem -Recurse -Filter '*.Koans.ps1' |
                Get-Command { $_.FullName } |
                Where-Object { $_.ScriptBlock.Attributes.TypeID -match 'Koan' }

                Assert-MockCalled Invoke-Koan -Times ($ValidKoans.Count)
            }
        }

        Context 'With -ClearScreen Switch' {
            BeforeAll {
                Mock Clear-Host { }
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Invoke-Koan -ModuleName 'PSKoans' { }

                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Initialize-KoanDirectory -Confirm:$false
            }

            It 'should not produce output' {
                Measure-Karma -ClearScreen | Should -Be $null
            }

            It 'should clear the screen' {
                Assert-MockCalled Clear-Host -Times 1
            }

            It 'should write the meditation prompts' {
                Assert-MockCalled Show-MeditationPrompt -Times 2
            }

            It 'should Invoke-Pester on each of the koans' {
                $ValidKoans = Get-PSKoanLocation | Get-ChildItem -Recurse -Filter '*.Koans.ps1' |
                Get-Command { $_.FullName } |
                Where-Object { $_.ScriptBlock.Attributes.TypeID -match 'Koan' }

                Assert-MockCalled Invoke-Koan -Times ($ValidKoans.Count)
            }
        }

        Context 'With Nonexistent Koans Folder / No Koans Found' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Measure-Koan -ModuleName 'PSKoans' { }
                Mock Get-Koan -ModuleName 'PSKoans' { }
                Mock Initialize-KoanDirectory -ModuleName 'PSKoans' { throw 'Prevent recursion' }
                Mock Write-Warning
            }

            It 'should attempt to populate koans and then recurse to reassess' {
                { Measure-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
            }

            It 'should display only the greeting prompt' {
                Assert-MockCalled Show-MeditationPrompt -Times 1
            }

            It 'should display a warning before initiating a reset' {
                Assert-MockCalled Write-Warning
            }

            It 'throws an error if a Topic is specified that matches nothing' {
                { Measure-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ExpectedMessage 'Could not find any koans'
            }
        }

        Context 'With -ListTopics Parameter' {
            BeforeAll {
                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Initialize-KoanDirectory -Confirm:$false
            }

            It 'should list all the koan topics' {
                $KoanTopics = Get-PSKoanLocation |
                Get-ChildItem -Recurse -File -Filter *.Koans.ps1 |
                ForEach-Object { $_.BaseName -replace '\.Koans$' }
                @(Measure-Karma -ListTopics) | Should -Be $KoanTopics
            }
        }

        Context 'With -Topic Parameter' {
            BeforeAll {
                Mock Show-MeditationPrompt -ModuleName 'PSKoans' { }
                Mock Invoke-Koan -ModuleName 'PSKoans' { }

                $TestLocation = 'TestDrive:{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
                Set-PSKoanLocation -Path $TestLocation

                Initialize-KoanDirectory -Confirm:$false

                $TestCases = @(
                    @{ Topic = @( 'AboutAssertions' ) }
                    @{ Topic = @( 'AboutArrays', 'AboutConditionals', 'AboutComparison' ) }
                )
            }

            It 'should Invoke-Pester on only the topics selected: <Topic>' {
                param([string[]] $Topic)

                Measure-Karma -Topic $Topic
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

                {Measure-Karma -Topic SingleTopicTest} | Should -Not -Throw

                Set-PSKoanLocation $TestLocation
            }
        }

        Context 'With -Reset Switch' {
            BeforeAll {
                Mock Initialize-KoanDirectory -ModuleName 'PSKoans' -ParameterFilter { -not $Topic } -MockWith { }
                Mock Initialize-KoanDirectory -ModuleName 'PSKoans' -ParameterFilter { $Topic } -MockWith { $Topic }

                $TopicTestCases = @(
                    @{ Topic = @( 'AboutArrays' ) }
                    @{ Topic = @( 'AboutTypeOperators', 'AboutHashtables' ) }
                )
            }

            It 'should not produce output' {
                Measure-Karma -Reset | Should -BeNullOrEmpty
            }

            It 'should call Initialize-KoanDirectory' {
                Assert-MockCalled Initialize-KoanDirectory -Times 1 -ParameterFilter { -not $Topic }
            }

            It 'should only target the specified topic "<Topic>" when -Topic is used' {
                param([string[]] $Topic)

                Measure-Karma -Reset -Topic $Topic | Should -Be $Topic
                Assert-MockCalled Initialize-KoanDirectory -Times 1 -ParameterFilter { $Topic }
            } -TestCases $TopicTestCases
        }

        Context 'With -Contemplate Switch' {

            Context 'VS Code Installed' {
                BeforeAll {
                    Mock Get-Command { $true }
                    Mock Start-Process { $FilePath }
                }

                It 'should start VS Code with Start-Process' {
                    Measure-Karma -Contemplate | Should -Be 'code'

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
                    Measure-Karma -Meditate | Should -BeNullOrEmpty
                }
                It 'should open the koans directory with Invoke-Item' {
                    Assert-MockCalled Get-Command -Times 1
                    Assert-MockCalled Invoke-Item -Times 1
                }
            }
        }
    }
}
