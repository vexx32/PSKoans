using module PSKoans

InModuleScope 'PSKoans' {
    Describe 'Initialize-KoanDirectory' {

        Context 'Mocked Commands' {
            BeforeAll {
                Mock Remove-Item {}
                Mock Copy-Item {}
            }

            Context 'Koan Folder Exists' {
                BeforeAll {
                    Mock Test-Path {$true}
                }

                It 'should not produce output' {
                    Initialize-KoanDirectory -Confirm:$false | Should -BeNullOrEmpty
                }

                It 'should try to remove the existing folder and then copy files' {
                    Assert-MockCalled Test-Path -Times 1
                    Assert-MockCalled Remove-Item -Times 1
                    Assert-MockCalled Copy-Item -Times 1
                }
            }

            Context 'Koan Folder Does Not Exist' {
                BeforeAll {
                    Mock Test-Path {$false}
                }

                It 'should not produce output' {
                    Initialize-KoanDirectory -Confirm:$false
                }
                It 'should just copy files' {
                    Assert-MockCalled Test-Path -Times 1
                    Assert-MockCalled Remove-Item -Times 0
                    Assert-MockCalled Copy-Item -Times 1
                }
            }
        }

        Context 'Practical Tests with TestDrive' {
            BeforeAll {
                if ($env:PSKoans_Folder) {
                    $LocalKoanFolder = $env:PSKoans_Folder
                }
                $env:PSKoans_Folder = "TestDrive:/Koans"

                $KoanFiles = Get-ChildItem -Path $script:ModuleFolder -Recurse -File -Filter '*.Koans.ps1' | ForEach-Object {
                    @{File = $_.FullName -replace '.+[/\\]Koans[/\\]'}
                }
            }

            Context 'Koan Folder Exists' {
                BeforeAll {
                    New-Item -ItemType Directory -Path $env:PSKoans_Folder > $null

                    $DummyFiles = 1..10 | ForEach-Object {
                        $FileName = '{0:000}' -f $_
                        1..($_ * 10) | Set-Content -Path "$env:PSKoans_Folder/$FileName"
                        @{Path = "$env:PSKoans_Folder/$FileName"}
                    }
                }

                It 'should not produce output' {
                    Initialize-KoanDirectory -Confirm:$false | Should -BeNullOrEmpty
                }

                It 'should remove the file from: <Path>' -TestCases $DummyFiles {
                    param($Path)

                    Test-Path -Path $Path | Should -BeFalse
                }

                It 'should copy <File> to the Koans folder' -TestCases $KoanFiles {
                    param($File)

                    Test-Path -Path "$env:PSKoans_Folder/$File" | Should -BeTrue

                    $CopiedFile = Get-Item -Path "$env:PSKoans_Folder/$File"
                    $OriginalFile = $script:ModuleFolder | Join-Path -ChildPath "Koans/$File" | Get-Item
                    $OriginalHash = Get-FileHash -Path $CopiedFile.FullName
                    $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                    # Verify the files are the same
                    $CopiedFile.Length | Should -Be $OriginalFile.Length
                    $CopiedHash.Hash | Should -Be $OriginalHash.Hash
                }
            }

            Context 'Koan Folder Does Not Exist' {

                It 'should not produce output' {
                    Initialize-KoanDirectory -Confirm:$false | Should -BeNullOrEmpty
                }

                It 'should copy <File> to the Koans folder' -TestCases $KoanFiles {
                    param($File)

                    Test-Path -Path "$env:PSKoans_Folder/$File" | Should -BeTrue

                    $CopiedFile = Get-Item -Path "$env:PSKoans_Folder/$File"
                    $OriginalFile = $script:ModuleFolder | Join-Path -ChildPath "Koans/$File" | Get-Item
                    $OriginalHash = Get-FileHash -Path $CopiedFile.FullName
                    $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                    # Verify the files are the same
                    $CopiedFile.Length | Should -Be $OriginalFile.Length
                    $CopiedHash.Hash | Should -Be $OriginalHash.Hash
                }
            }

            AfterAll {
                if ($LocalKoanFolder) {
                    $env:PSKoans_Folder = $LocalKoanFolder
                }
            }
        }
    }
}