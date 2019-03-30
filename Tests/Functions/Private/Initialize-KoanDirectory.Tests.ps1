#Requires -Modules PSKoans

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

            Context 'With -Topic Parameter' {
                BeforeAll {
                    Mock Copy-Item {}
                }

                It 'should call Copy-Item' {
                    Initialize-KoanDirectory -Confirm:$false -Topic 'AboutArrays', 'AboutAssignmentAndArithmetic'
                    Assert-MockCalled Copy-Item -Times 1
                }
            }
        }

        Context 'Practical Tests with TestDrive' {
            BeforeAll {
                if (Get-PSKoanLocation) {
                    $LocalKoanFolder = Get-PSKoanLocation
                }

                Set-PSKoanLocation -Path "TestDrive:/Koans"

                $KoanFiles = Get-ChildItem -Path $script:ModuleRoot -Recurse -File -Filter '*.Koans.ps1' | ForEach-Object {
                    @{File = $_.FullName -replace '.+[/\\]Koans[/\\]'}
                }
            }

            Context 'Koan Folder Exists' {
                BeforeAll {
                    Get-PSKoanLocation | New-Item -Path {$_} -ItemType Directory > $null

                    $DummyFiles = 1..10 | ForEach-Object {
                        $FileName = '{0:000}' -f $_
                        1..($_ * 10) | Set-Content -Path "$(Get-PSKoanLocation)/$FileName"
                        @{ Path = "$(Get-PSKoanLocation)/$FileName" }
                    }

                    ${/} = [System.IO.Path]::DirectorySeparatorChar
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

                    Get-PSKoanLocation |
                        Join-Path -ChildPath $File |
                        Test-Path |
                        Should -BeTrue

                    $CopiedFile = Get-PSKoanLocation | Join-Path -ChildPath $File | Get-Item
                    $OriginalFile = $script:ModuleRoot | Join-Path -ChildPath "Koans${/}$File" | Get-Item

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

                    Get-PSKoanLocation |
                        Join-Path -ChildPath $File |
                        Test-Path |
                        Should -BeTrue

                    $CopiedFile = Get-PSKoanLocation | Join-Path -ChildPath $File | Get-Item
                    $OriginalFile = $script:ModuleRoot | Join-Path -ChildPath "Koans${/}$File" | Get-Item

                    $OriginalHash = Get-FileHash -Path $CopiedFile.FullName
                    $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                    # Verify the files are the same
                    $CopiedFile.Length | Should -Be $OriginalFile.Length
                    $CopiedHash.Hash | Should -Be $OriginalHash.Hash
                }
            }

            Context 'Resetting Specific Topics' {
                BeforeAll {
                    $TopicTests = @(
                        @{ Topic = 'AboutArrays' }
                        @{ Topic = 'AboutVariables'  }
                        @{ Topic = 'AboutSplatting'  }
                    )

                    Initialize-KoanDirectory -Confirm:$false
                }

                It 'should copy <Topic> to the Koans folder' -TestCases $TopicTests {
                    param($Topic)

                    $PathFragment = $KoanFiles.File -match $Topic

                    $File = Get-PSKoanLocation |
                        Join-Path -ChildPath $PathFragment |
                        Get-Item

                    Clear-Content -Path $File

                    $OriginalFile = $script:ModuleRoot |
                        Join-Path -ChildPath "Koans${/}$PathFragment" |
                        Get-Item

                    Initialize-KoanDirectory -Confirm:$false -Topic $Topic

                    $OriginalHash = Get-FileHash -Path $File.FullName
                    $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                    # Verify the files are the same
                    $CopiedFile.Length | Should -Be $OriginalFile.Length
                    $CopiedHash.Hash | Should -Be $OriginalHash.Hash
                }
            }

            AfterAll {
                if ($LocalKoanFolder) {
                    Set-PSKoanLocation -Path $LocalKoanFolder
                }
            }
        }
    }
}
