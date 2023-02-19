#Requires -Modules PSKoans

Describe 'Get-PSKoan' {

    BeforeAll {
        Mock 'Get-PSKoanLocation' {
            Join-Path $TestDrive 'PSKoans'
        }

        Mock 'Get-PSKoanLocation' {
            Join-Path $TestDrive 'PSKoans'
        } -ModuleName 'PSKoans'

        Update-PSKoan -Confirm:$false

        # Stage test module
        $path = Join-Path -Path (Get-PSKoanLocation) 'Modules\TestModule'
        New-Item -Path $path -ItemType Directory -Force
        Set-Content -Path (Join-Path -Path $path -ChildPath 'AboutSomething.Koans.ps1') -Value @'
            using module PSKoans
            [Koan(Position = 1, Module = 'TestModule')]
            param()

            Describe 'AboutSomething' {
                It 'first' {
                    $true | Should -BeTrue
                }
            }
'@
    }

    It 'retrieves all except module-specific koan files' {
        $Files = Get-ChildItem -Path (Get-PSKoanLocation) -Filter *.Koans.ps1 -Recurse -File |
            Where-Object FullName -NotMatch 'PSKoans[\\/]Modules[\\/]'

        (Get-PSKoan).Topic.Count | Should -Be $Files.Count
    }

    It 'retrieves specific requested files with -Topic <Topic>' -TestCases @(
        @{ Topic = 'AboutArrays' }
        @{ Topic = 'AboutVariables' }
        @{ Topic = 'AboutTypeOperators' }
        @{ Topic = 'AboutLists' }
        @{ Topic = 'AboutVariables', 'AboutLists' }
    ) {
        (Get-PSKoan -Topic $Topic).Topic | Should -Be $Topic
    }

    It 'retrieves specific requested files with -Module <Module>' -TestCases @(
        @{ Topic = 'AboutSomething'; Module = 'TestModule' }
    ) {
        (Get-PSKoan -Module $Module -Scope User).Topic | Should -Be $Topic
    }

    It 'should throw a terminating error if a file is blocked' -Skip:($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.Platform -ne 'Win32NT') {
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
