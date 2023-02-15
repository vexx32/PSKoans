#Requires -Modules PSKoans

Describe 'Get-Karma' {
    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
        $originalLocation = Get-PSKoanLocation
        Set-PSKoanLocation -Path (Join-Path $TestDrive -ChildPath 'PSKoans')
        Update-PSKoan -Confirm:$false
    }

    AfterAll {
        Set-PSKoanLocation -Path $originalLocation
    }

    Context 'Default Behaviour' {

        BeforeAll {
            Mock 'Measure-Koan' -MockWith { 4 } @module
            Mock 'Invoke-Koan' @module {
                [PSCustomObject]@{
                    PassedCount = 0
                    FailedCount = 4
                    Failed      = @()
                }
            }
            Update-PSKoan -Confirm:$false

            $Result = Get-Karma
        }

        It 'produces a hashtable with data' {
            $Result.PSTypeNames[0] | Should -Be 'PSKoans.Result'
            $Result.KoansPassed | Should -Be 0
        }

        It 'calls Measure-Koan on each file to count koans' {
            Should -Invoke 'Measure-Koan' -Scope Context @module
        }

        It 'calls Invoke-Koan on each topic file until it fails a test' {
            Should -Invoke 'Invoke-Koan' -Times 1 @module -Scope Context
        }

        It 'populates the $script:CurrentTopic variable' {
            $currentTopic = InModuleScope 'PSKoans' { $script:CurrentTopic }
            $currentTopic | Should -BeOfType [hashtable]
            $currentTopic.Count | Should -Be 4
            @('Name', 'Completed', 'Total', 'CurrentLine') | Should -BeIn $currentTopic.Keys
        }
    }

    Context 'With Nonexistent Koans Folder / No Koans Found' {

        BeforeAll {
            Mock 'Measure-Koan' @module
            Mock 'Update-PSKoan' -MockWith { throw 'Prevent recursion' } @module
            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'User' } @module
            Mock 'Write-Warning' @module
        }

        It 'should attempt to populate koans and then recurse to reassess' {
            { Get-Karma } | Should -Throw -ExpectedMessage 'Prevent recursion'
            Should -Invoke 'Update-PSKoan' -Scope Context @module
        }

        It 'displays a warning before initiating a reset' {
            { Get-Karma } | Should -Throw
            Should -Invoke 'Write-Warning' -Scope Context @module
        }

        It 'throws an error if a Topic is specified that matches nothing' {
            { Get-Karma -Topic 'AboutAbsolutelyNothing' } | Should -Throw -ErrorId 'PSKoans.TopicNotFound,Get-Karma'
        }
    }

    Context 'With -ListTopics Parameter' {

        BeforeAll {
            Mock 'Get-PSKoan' @module
        }

        It 'lists all the koan topics' {
            Get-Karma -ListTopics

            Should -Invoke 'Get-PSKoan' @module
        }
    }

    Context 'With -Topic Parameter' {

        BeforeAll {
            Mock 'Measure-Koan' @module { [int]::MaxValue }
            Mock 'Invoke-Koan' @module
        }

        It 'calls Invoke-Koan on only the topics selected: <Topic>' -TestCases @(
            @{ Topic = @( 'AboutAssertions' ) }
            @{ Topic = @( 'AboutArrays', 'AboutConditionals', 'AboutComparison' ) }
        ) {
            Get-Karma -Topic $Topic

            Should -Invoke 'Invoke-Koan' -Times @($Topic).Count @module
        }
    }

    Context 'Behaviour When All Koans Are Completed' {

        BeforeAll {
            Mock 'Measure-Koan' @module -MockWith { 2 }

            $TestFile = Join-Path -Path (Get-PSKoanLocation) -ChildPath 'Group\SelectedTopicTest.Koans.ps1'
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
            }
            catch {
                # Ignore this. Error tests follow.
            }
        }

        It 'does not divide by zero if all Koans are completed' {
            { Get-Karma -Topic SelectedTopicTest } | Should -Not -Throw
        }

        It 'outputs the result object' {
            $Result | Should -Not -BeNullOrEmpty
            $Result.PSTypeNames | Should -Contain 'PSKoans.CompleteResult'
        }

        It 'indicates completion' {
            $Result.Complete | Should -BeTrue
        }

        It 'indicates number of koans passed' {
            $Result.KoansPassed | Should -Be 2
        }

        It 'indicates total number of koans' {
            $Result.TotalKoans | Should -Be 2
        }

        It 'indicates the requested topic' {
            $Result.RequestedTopic | Should -Be 'SelectedTopicTest'
        }
    }
}
