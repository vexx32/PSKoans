#Requires -Modules PSKoans

#region Discovery
$SkipTests = $PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.Platform -ne 'Win32NT'
#endregion Discovery

Describe 'Assert-UnblockedFile' -Skip:$SkipTests {

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
            param()

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

    Context 'File With External Zone Identifier' {

        BeforeEach {
            Set-Content -Path $defaultParams.FileInfo.FullName -Stream Zone.Identifier -Value @'
                [ZoneTransfer]
                ZoneId=3
                ReferrerUrl=C:\Downloads\File.zip
'@
        }

        It 'should throw a terminating error if the file is blocked' {
            {
                InModuleScope 'PSKoans' -Parameters @{ Params = $defaultParams } {
                    param($Params)
                    Assert-UnblockedFile @Params
                }
            } | Should -Throw -ErrorId 'PSKoans.KoanFileIsBlocked'
        }
    }

    Context 'File Without Zone Identifier' {

        It 'returns the original object with -PassThru if the file is not blocked' {
            InModuleScope 'PSKoans' -Parameters @{ Params = $defaultParams } {
                param($Params)
                Assert-UnblockedFile @Params
            } | Should -BeOfType [System.IO.FileInfo]
        }
    }
}
