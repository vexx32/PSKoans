# This is required due to having to parse the KoanAttribute to verify the correct files are returned
# Using a relative path to the module being tested removes duplicate loading of the module.
using module ..\..\..\PSKoans\PSKoans.psd1

Describe 'Get-Koan' {
    BeforeAll {
        ${/} = [System.IO.Path]::DirectorySeparatorChar
        $TestLocation = "TestDrive:${/}PSKoans"

        Set-PSKoanLocation -Path $TestLocation
        Update-PSKoan -Confirm:$false
    }

    It 'should retrieve all the koan files' {
        $Files = Get-ChildItem -Path $TestLocation -Filter *.Koans.ps1 -Recurse -File |
            Get-Command { $_.FullName } |
            Where-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }.Count -gt 0 } |
            Sort-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }.Position }

        InModuleScope 'PSKoans' { (Get-Koan).Name } | Should -Be $Files.Name
    }

    It 'should retrieve specific requested files with -Topic' {
        InModuleScope 'PSKoans' {
            (Get-Koan -Topic 'AboutArrays').Name | Should -Be 'AboutArrays.Koans.ps1'
            (Get-Koan -Topic 'AboutVariables').Name | Should -Be 'AboutVariables.Koans.ps1'
            (Get-Koan -Topic 'AboutTypeOperators').Name | Should -Be 'AboutTypeOperators.Koans.ps1'
            (Get-Koan -Topic 'AboutLists').Name | Should -Be 'AboutLists.Koans.ps1'
            (Get-Koan -Topic 'AboutLists', 'AboutVariables').Name | Should -Be 'AboutVariables.Koans.ps1', 'AboutLists.Koans.ps1'
        }
    }

    It 'should throw a terminating error if the file is blocked' {
        $testFile = Get-ChildItem -Path $TestLocation -Filter AboutArrays.Koans.ps1 -Recurse -File |
            Select-Object -First 1

        Set-Content -Path $testFile.FullName -Stream Zone.Identifier -Value @'
[ZoneTransfer]
ZoneId=3
ReferrerUrl=C:\Downloads\File.zip
'@

        InModuleScope 'PSKoans' {
            { Get-Koan -Topic AboutArrays } | Should -Throw -ErrorId PSKoans.KoanFileIsBlocked
        }
    }
}
