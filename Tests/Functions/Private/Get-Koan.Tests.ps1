# This is required due to having to parse the KoanAttribute to verify the correct files are returned
using module PSKoans

Describe 'Get-Koan' {
    BeforeAll {
        ${/} = [System.IO.Path]::DirectorySeparatorChar
        $TestLocation = "TestDrive:${/}PSKoans"

        Set-PSKoanLocation -Path $TestLocation
        InModuleScope 'PSKoans' { Initialize-KoanDirectory -Confirm:$false }
    }

    It 'should retrieve all the koan files' {
        $Files = Get-ChildItem -Path $TestLocation -Filter *.Koans.ps1 -Recurse -File |
            Get-Command { $_.FullName } |
            Where-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'KoanAttribute' }.Count -gt 0 } |
            Sort-Object { $_.ScriptBlock.Attributes.Where{ $_.TypeID -match 'KoanAttribute' }.Position }

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
}
