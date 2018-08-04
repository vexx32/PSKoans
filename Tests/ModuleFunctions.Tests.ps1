$ProjectRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', ''
$ModuleFolder = "$ProjectRoot\PSKoans"
Import-Module $ModuleFolder -Prefix "TST"

Describe 'Get-Blank' {

    It 'should not produce output' {
        Get-TSTBlank | Should -BeNullOrEmpty
    }
}

Describe 'Get-Enlightenment' {

    Context 'Get-Enlightenment (Default Behaviour)' {
        BeforeAll {
            Mock Clear-Host
            Mock Write-MeditationPrompt
            Mock Get-ChildItem {Get-Item -Path "$ModuleFolder\Koans\*\*" -Filter '*.Koans.ps1'}
            Mock Invoke-Pester
        }

        It 'should not produce output' {
            Get-TSTEnlightenment | Should -BeNullOrEmpty
        }

        It 'should clear the screen' {
            Assert-MockCalled Clear-Host -Times 1
        }

        It 'should write the meditation prompts' {
            Assert-MockCalled Write-MeditationPrompt -Times 2
        }

        It 'should Invoke-Pester globally, and again for every file in the Koans folder' {
            Assert-MockCalled Invoke-Pester -Times ((Get-ChildItem).Count + 1)
        }
    }

    Context 'Get-Enlightenment -Reset' {
        BeforeAll {
            Mock Initialize-KoanDirectory
        }

        It 'should not produce output' {
            Get-TSTEnlightenment -Reset | Should -BeNullOrEmpty
        }

        It 'should call Initialize-KoanDirectory' {
            Assert-MockCalled Initialize-KoanDirectory -Times 1
        }
    }

    Context 'Get-Enlightenment -Meditate' {
        BeforeAll {
            Mock Start-Process {$FilePath}
            Mock Invoke-Item
        }

        Context 'VS Code Installed' {
            BeforeAll {
                Mock Get-Command {$true}
            }

            It 'should start VS Code with Start-Process' {
                Get-TSTEnlightenment -Meditate | Should -Be 'code'

                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Start-Process -Times 1
            }
        }

        Context 'VS Code Not Installed' {
            BeforeAll {
                Mock Get-Command {$false}
            }

            It 'should not produce output' {
                Get-TSTEnlightenment -Meditate | Should -BeNullOrEmpty
            }
            It 'should open the koans directory with Invoke-Item' {
                Assert-MockCalled Get-Command -Times 1
                Assert-MockCalled Invoke-Item -Times 1
            }
        }
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

            It 'should not produce output' {
                Initialize-KoanDirectory -Confirm:$false | Should -BeNullOrEmpty
            }

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

            It 'should not produce output' {
                Initialize-KoanDirectory -Confirm:$false | Should -BeNullOrEmpty
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
                Write-MeditationPrompt -Greeting | Should -BeNullOrEmpty

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

            It 'should only display the complete prompt' {
                Write-MeditationPrompt @Meditation | Should -BeNullOrEmpty

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

            It 'should display only the enlightened prompt' {
                Write-MeditationPrompt @Meditation | Should -BeNullOrEmpty

                Assert-MockCalled Write-Host -Times 3
            }
        }
    }
}