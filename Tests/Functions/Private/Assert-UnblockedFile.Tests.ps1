#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
    InModuleScope PSKoans {
        Describe Assert-UnblockedFile {
            BeforeAll {
                $defaultParams = @{
                    FileInfo = [System.IO.FileInfo](Join-Path -Path $TestDrive -ChildPath 'AboutSomething.Koans.ps1')
                    PassThru = $true
                }
            }

            BeforeEach {
                Set-Content -Path $defaultParams.FileInfo.FullName -Value @'
                    using module PSKoans

                    [Koan(Position = 1)]
                    param ( )

                    Describe 'About something' {
                        It 'Has examples' {
                            $true | Should -BeTrue
                        }
                    }
'@
            }

            AfterEach {
                Remove-Item -Path $defaultParams.FileInfo.FullName
            }

            Context 'File is blocked' {
                BeforeEach {
                    Set-Content -Path $defaultParams.FileInfo.FullName -Stream Zone.Identifier -Value @'
                        [ZoneTransfer]
                        ZoneId=3
                        ReferrerUrl=C:\Downloads\File.zip
'@
                }

                It 'should throw a terminating error if the file is blocked' {
                    { Assert-UnblockedFile @defaultParams } | Should -Throw -ErrorId 'PSKoans.KoanFileIsBlocked'
                }
            }

            Context 'File is not blocked' {
                It 'returns the original object with -PassThru if the file is not blocked' {
                    Assert-UnblockedFile @defaultParams | Should -BeOfType [System.IO.FileInfo]
                }
            }
        }
    }
}
