$ProjectRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', ''
$ModuleFolder = "$ProjectRoot\PSKoans"
Import-Module $ModuleFolder -Prefix "TST"

Describe 'Get-Blank' {

    It 'should output $null' {
        Get-TSTBlank | Should -Be $null
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
                $OriginalFile = Get-Item -Path "$ModuleFolder\$File"
                $OriginalHash = Get-FileHash -Path $CopiedFile.FullName
                $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                # Verify the files are the same
                $CopiedFile.Length | Should -Be $OriginalFile.Length
                $CopiedHash | Should -Be $OriginalHash
            }
        }

        Context 'Koan Folder Does Not Exist' {

            $TestCases = Get-ChildItem -Path "$ModuleFolder\Koans" -Recurse -File -Filter '*.Koans.ps1' | ForEach-Object {
                @{File = $_.FullName -replace '.+\\Koans\\'}
            }
            It 'should copy <File> to the Koans folder' -TestCases $TestCases {
                param($File)

                Test-Path -Path "$env:PSKoans_Folder\$File" | Should -BeTrue

                $CopiedFile = Get-Item -Path "$env:PSKoans_Folder\$File"
                $OriginalFile = Get-Item -Path "$ModuleFolder\$File"
                $OriginalHash = Get-FileHash -Path $CopiedFile.FullName
                $CopiedHash = Get-FileHash -Path $OriginalFile.FullName

                # Verify the files are the same
                $CopiedFile.Length | Should -Be $OriginalFile.Length
                $CopiedHash | Should -Be $OriginalHash
            }
        }

        AfterAll {
            if ($LocalKoanFolder) {
                $env:PSKoans_Folder = $LocalKoanFolder
            }
        }
    }
}

