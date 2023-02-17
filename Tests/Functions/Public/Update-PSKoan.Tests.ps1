#Requires -Modules PSKoans

Describe 'Update-PSKoan' {

    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
    }

    Context 'Mocked Commands' {

        BeforeAll {
            Mock 'Remove-Item' @module
            Mock 'Copy-Item' @module
            Mock 'New-Item' @module
            Mock 'Move-Item' @module
            Mock 'Update-PSKoanFile' @module

            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'Module' } -MockWith {
                [PSCustomObject]@{
                    Topic = 'Missing'
                    Path  = 'Module\Group\AboutSomethingMissing.Koans.ps1'
                }
                [PSCustomObject]@{
                    Topic = 'IncorrectPath'
                    Path  = 'Module\Group\AboutSomethingIncorrectPath.Koans.ps1'
                }
                [PSCustomObject]@{
                    Topic = 'Existing'
                    Path  = 'Module\Group\AboutSomethingExisting.Koans.ps1'
                }
            } @module

            Mock 'Get-PSKoan' -ParameterFilter { $Scope -eq 'User' } -MockWith {
                [PSCustomObject]@{
                    Topic = 'IncorrectPath'
                    Path  = 'Module\RetiredGroup\AboutSomethingIncorrectPath.Koans.ps1'
                }
                [PSCustomObject]@{
                    Topic = 'RetiredTopic'
                    Path  = 'Module\RetiredGroup\AboutSomethingRetiredTopic.Koans.ps1'
                }
                [PSCustomObject]@{
                    Topic = 'Existing'
                    Path  = 'Module\Group\AboutSomethingExisting.Koans.ps1'
                }
            } @module
        }

        It 'should not produce output' {
            Update-PSKoan -Confirm:$false | Should -BeNullOrEmpty
        }

        It 'should copy missing topic files' {
            Should -Invoke 'Copy-Item' -Times 1 -Scope Context @module
        }

        It 'should move incorrectly placed topics' {
            Should -Invoke 'Remove-Item' -Times 1 -Scope Context @module
        }

        It 'should remove discarded topics' {
            Should -Invoke 'Remove-Item' -Times 1 -Scope Context @module
        }

        It 'should update topics which exist in module and koan path' {
            Should -Invoke 'Update-PSKoanFile' @module -Times 2 -Scope Context
        }
    }

    Context 'Practical Tests with TestDrive' {

        BeforeAll {
            Mock 'Get-PSKoanLocation' {
                Join-Path -Path $TestDrive -ChildPath 'PSKoans'
            }
            Mock 'Get-PSKoanLocation' {
                Join-Path -Path $TestDrive -ChildPath 'PSKoans'
            } @module

            New-Item -Path (Get-PSKoanLocation) -ItemType Directory
            Update-PSKoan -Confirm:$false

            $file = Get-ChildItem -Path (Get-PSKoanLocation) -Filter *.koans.ps1 -File -Recurse |
                Select-Object -First 1
        }

        It 'should copy missing topic files' {
            $file | Remove-Item
            $file.FullName | Should -Not -Exist

            Update-PSKoan -Confirm:$false

            $file.FullName | Should -Exist
        }

        It 'should move incorrectly placed topics' {
            $directory = New-Item -Path (Join-Path -Path $TestDrive -ChildPath 'PSKoans\Wrong') -ItemType Directory
            $file | Move-Item -Destination $directory.FullName
            $file.FullName | Should -Not -Exist

            Update-PSKoan -Confirm:$false

            $file.FullName | Should -Exist
        }

        It 'should remove discarded topics' {
            $oldTopicPath = Join-Path $TestDrive 'PSKoans\Foundations\OldTopic.koans.ps1'
            $file | Copy-Item -Destination $oldTopicPath
            $oldTopicPath | Should -Exist

            Update-PSKoan -Confirm:$false

            $oldTopicPath | Should -Not -Exist
        }
    }
}
