#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Update-PSKoan' {
        Context 'Mocked Commands' {
            BeforeAll {
                Mock Remove-Item { }
                Mock Copy-Item { }
                Mock New-Item { }
                Mock Move-Item { }
                Mock Update-PSKoanFile { }

                Mock Get-PSKoanLocation {
                    'TestDrive:\Koans'
                }

                Mock Get-ChildItem -ParameterFilter { $LiteralPath -match 'PSKoans' } -MockWith {
                    [System.IO.FileInfo]'Module\Koans\Missing.Koans.ps1'
                    [System.IO.FileInfo]'Module\Koans\Right\Path.Koans.ps1'
                    [System.IO.FileInfo]'Module\Koans\Update.Koans.ps1'
                }

                Mock Get-ChildItem -ParameterFilter { $LiteralPath -match 'TestDrive'} -MockWith {
                    [System.IO.FileInfo]"${TestDrive}\Koans\Wrong\Path.Koans.ps1"
                    [System.IO.FileInfo]"${TestDrive}\Koans\Update.Koans.ps1"
                    [System.IO.FileInfo]"${TestDrive}\Koans\Remove.Koans.ps1"
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
                if (Get-PSKoanLocation) {
                    $LocalKoanFolder = Get-PSKoanLocation
                }

                Set-PSKoanLocation -Path "TestDrive:/Koans"

                Initialize-KoanDirectory -Confirm:$false | Should -BeNullOrEmpty

                $file = Get-ChildItem -Path (Get-PSKoanLocation) -Filter *.koans.ps1 -File -Recurse | Select-Object -First 1
            }

            It 'should copy missing topic files' {
                $file | Remove-Item
                $file.FullName | Should -Not -Exist

                Update-PSKoan -Confirm:$false

                $file.FullName | Should -Exist
            }

            It 'should move incorrectly placed topics' {
                $directory = New-Item (Join-Path $TestDrive 'Koans\Wrong') -ItemType Directory
                $file | Move-Item -Destination $directory.FullName
                $file.FullName | Should -Not -Exist

                Update-PSKoan -Confirm:$false

                $file.FullName | Should -Exist
            }

            It 'should remove discarded topics' {
                $oldTopicPath = Join-Path $TestDrive 'Koans\OldTopic.koans.ps1'
                $file | Copy-Item -Destination $oldTopicPath
                $oldTopicPath | Should -Exist

                Update-PSKoan -Confirm:$false

                $oldTopicPath | Should -Not -Exist
            }

            AfterAll {
                if ($LocalKoanFolder) {
                    Set-PSKoanLocation -Path $LocalKoanFolder
                }
            }
        }
    }
}