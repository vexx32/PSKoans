#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

InModuleScope PSKoans {
    Describe 'Get-PSKoan' {
        BeforeAll {
            Mock Get-PSKoanLocation {
                Join-Path $TestDrive 'PSKoans'
            }

            Update-PSKoan -Confirm:$false

            # Stage test module
            $path = Join-Path -Path (Get-PSKoanLocation) 'Modules\TestModule'
            New-Item -Path $path -ItemType Directory -Force
            Set-Content -Path (Join-Path -Path $path -ChildPath 'AboutSomething.Koans.ps1') -Value @'
                using module PSKoans
                [Koan(Position = 1, Module = 'TestModule')]
                param( )

                Describe 'AboutSomething' {
                    It 'first' {
                        $true | Should -BeTrue
                    }
                }
'@
        }

        It 'should retrieve all except module-specific koan files' {
            $Files = Get-ChildItem -Path (Get-PSKoanLocation) -Filter *.Koans.ps1 -Recurse -File |
                Where-Object FullName -notmatch 'PSKoans[\\/]Modules[\\/]'

            (Get-PSKoan).Topic.Count | Should -Be $Files.Count
        }

        It 'should retrieve specific requested files with -Topic <Topic>' -TestCases @(
            @{ Topic = 'AboutArrays' }
            @{ Topic = 'AboutVariables' }
            @{ Topic = 'AboutTypeOperators' }
            @{ Topic = 'AboutLists' }
            @{ Topic = 'AboutVariables', 'AboutLists' }
        ) {
            param($Topic)

            (Get-PSKoan -Topic $Topic).Topic | Should -Be $Topic
        }

        It 'should retrieve specific requested files with -Module <Module>' -TestCases @(
            @{ Topic = 'AboutSomething'; Module = 'TestModule' }
        ) {
            param($Topic, $Module)

            (Get-PSKoan -Module $Module -Scope User).Topic | Should -Be $Topic
        }

        if ($PSVersionTable.PSEdition -eq 'Desktop' -or $PSVersionTable.Platform -eq 'Win32NT') {
            It 'should throw a terminating error if a file is blocked' {
                $testFile = Get-ChildItem -Path (Get-PSKoanLocation) -Filter AboutArrays.Koans.ps1 -Recurse -File |
                    Select-Object -First 1

                Set-Content -Path $testFile.FullName -Stream Zone.Identifier -Value @'
                    [ZoneTransfer]
                    ZoneId=3
                    ReferrerUrl=C:\Downloads\File.zip
'@

                { Get-PSKoan -Topic AboutArrays -Scope User } | Should -Throw -ErrorId PSKoans.KoanFileIsBlocked
            }
        }
    }
}
