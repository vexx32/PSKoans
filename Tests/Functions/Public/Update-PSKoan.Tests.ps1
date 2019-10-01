#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

InModuleScope 'PSKoans' {
    Describe 'Update-PSKoan' {
        BeforeAll {
            Mock Get-PSKoanLocation {
                Join-Path -Path $TestDrive -ChildPath 'PSKoans'
            }
            New-Item -Path (Get-PSKoanLocation) -ItemType Directory
        }

        Context 'Mocked Commands' {
            BeforeAll {
                Mock Remove-Item
                Mock Copy-Item
                Mock New-Item
                Mock Move-Item
                Mock Update-PSKoanFile

                Mock Get-PSKoan -ParameterFilter { $Scope -eq 'Module' } -MockWith {
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
                }
                Mock Get-PSKoan -ParameterFilter { $Scope -eq 'User' } -MockWith {
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
                }
            }

            It 'should not produce output' {
                Update-PSKoan -Confirm:$false | Should -BeNullOrEmpty
            }

            It 'should copy missing topic files' {
                Assert-MockCalled Copy-Item -Times 1
            }

            It 'should move incorrectly placed topics' {
                Assert-MockCalled Remove-Item -Times 1
            }

            It 'should remove discarded topics' {
                Assert-MockCalled Remove-Item -Times 1
            }

            It 'should update topics which exist in module and koan path' {
                Assert-MockCalled Update-PSKoanFile -Times 2
            }
        }

        Context 'Practical Tests with TestDrive' {
            BeforeAll {
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
}
