$ProjectRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', ''
$ModuleFolder = "$ProjectRoot\PSKoans"
Import-Module $ModuleFolder -Prefix "TST"

Describe 'Get-Blank' {

    It 'should output $null' {
        Get-TSTBlank | Should -Be $null
    }
}

Describe 'Get-Enlightenment' {
    BeforeAll {
        Mock Initialize-KoanDirectory
        Mock Start-Process
        Mock Invoke-Item
    }
}

InModuleScope 'PSKoans' {
    Describe 'Initialize-KoanDirectory with Mocked Commands' -Tags 'Mock' {
        BeforeAll {
            Mock Remove-Item
            Mock Copy-Item
        }

        Context 'Koan Folder Exists' {
            BeforeAll {
                Mock Test-Path {$true}
            }

            It 'should try to remove the existing folder and then copy files' {
                Initialize-KoanDirectory -Confirm:$false

                Assert-MockCalled Test-Path -Times 1
                Assert-MockCalled Remove-Item -Times 1
                Assert-MockCalled Copy-Item -Times 1
            }
        }

        Context 'Koan Folder Does Not Exist' {
            BeforeAll {
                Mock Test-Path {$false}
            }

            It 'should just copy files' {
                Initialize-KoanDirectory -Confirm:$false

                Assert-MockCalled Test-Path -Times 1
                Assert-MockCalled Remove-Item -Times 0
                Assert-MockCalled Copy-Item -Times 1
            }
        }
    }

    Describe 'Initialize-KoanDirectory with TestDrive' -Tags 'TestDrive' {
        BeforeAll {
            if ($env:PSKoans_Folder) {
                $LocalKoanFolder = $env:PSKoans_Folder
            }
            $env:PSKoans_Folder = "TestDrive:\Koans"
        }

        Context 'Koan Folder Exists' {
            BeforeAll {
                New-Item -ItemType Directory -Path $env:PSKoans_Folder > $null

                $DummyFiles = 1..10 | ForEach-Object {
                    $FileName = '{0:000}' -f $_
                    1..($_ * 10) | Set-Content -Path "$env:PSKoans_Folder\$FileName"
                    @{Path = "$env:PSKoans_Folder\$FileName"}
                }
            }

            Initialize-KoanDirectory -Confirm:$false

            It 'should remove the file from: <Path>' -TestCases $DummyFiles {
                param($Path)

                Test-Path -Path $Path | Should -BeFalse
            }

            $TestCases = Get-ChildItem -Path "$ModuleFolder\Koans" -Recurse -File -Filter '*.Koans.ps1' | ForEach-Object {
                @{File = $_.FullName -replace '.+\\Koans\\'}
            }
            It 'should copy <File> to the Koans folder' -TestCases $TestCases {
                param($File)

                Test-Path -Path "$env:PSKoans_Folder\$File" | Should -BeTrue

                $CopiedFile = Get-Item -Path "$env:PSKoans_Folder\$File"
                $OriginalFile = Get-Item -Path "$ModuleFolder\Koans\$File"
                $OriginalHash = Get-FileHash -Path $CopiedFile.FullName
                $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                # Verify the files are the same
                $CopiedFile.Length | Should -Be $OriginalFile.Length
                $CopiedHash.Hash | Should -Be $OriginalHash.Hash
            }
        }

        Context 'Koan Folder Does Not Exist' {
            BeforeAll {
                $TestCases = Get-ChildItem -Path "$ModuleFolder\Koans" -Recurse -File -Filter '*.Koans.ps1' | ForEach-Object {
                    @{File = $_.FullName -replace '.+\\Koans\\'}
                }
            }

            Initialize-KoanDirectory -Confirm:$false

            It 'should copy <File> to the Koans folder' -TestCases $TestCases {
                param($File)

                Test-Path -Path "$env:PSKoans_Folder\$File" | Should -BeTrue

                $CopiedFile = Get-Item -Path "$env:PSKoans_Folder\$File"
                $OriginalFile = Get-Item -Path "$ModuleFolder\Koans\$File"
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

    Describe 'Write-MeditationPrompt' {
        BeforeAll {
            Mock Write-Host
            Mock Start-Sleep
            Mock Import-CliXml {"Test"}
        }

        Context 'Greeting Prompt' {

            It 'should only write a single string to host' {
                Write-MeditationPrompt -Greeting

                Assert-MockCalled Write-Host -Times 1
            }
        }

        Context 'Standard Prompt' {
            BeforeAll {
                $Meditation = @{
                    DescribeName = "TestDescribe"
                    Expectation  = "TestExpectation"
                    ItName       = "TestIt"
                    Meditation   = "TestMeditation"
                    KoansPassed  = 0
                    TotalKoans   = 100
                }
            }

            It 'should display the entire prompt' {
                Write-MeditationPrompt @Meditation

                Assert-MockCalled Import-Clixml -Times 1
                Assert-MockCalled Write-Host -Times 8
                Assert-MockCalled Start-Sleep -Times 3
            }
        }

        Context 'Enlightened Prompt' {
            BeforeAll {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = 100
                    TotalKoans  = 100
                }
            }

            It 'should display the enlightened prompt' {
                Write-MeditationPrompt @Meditation

                Assert-MockCalled Write-Host -Times 3
            }
        }
    }
}