#Requires -Modules PSKoans
[Koan(Position = 207)]
param()
<#
    Where-Object

    Where-Object is a pipeline cmdlet used to filter a collection of objects and return
    only those that match the specified condition.
#>
Describe 'Where-Object' {

    It 'can filter value-type collections' {
        $Collection = @(
            001, 002, 003, 004, 005, 006, 007
            008, 009, 010, 011, 012, 013, 014
            015, 016, 017, 018, 019, 020
        )

        $ContainsTwo = $Collection | Where-Object {$_ -match '2'}
        $ContainsTwo | Should -Be __
    }

    It 'can filter on object propertes' {
        $Collection = Get-ChildItem -Path $home -Recurse -Depth 2

        $ItemsWithNumbers = $Collection | Where-Object {$_.Name -match '\d'}
        $ItemsWithNumbers.Count | Should -Be __

        # Pipelines also work across line breaks (as long as the pipe is at the end of the line)
        $ItemsWithNumbers |
            Get-Random |
            Select-Object -ExpandProperty Name |
            Should -Be __
    }

    It 'supports simplified syntax' {
        $Collection = Get-ChildItem -Path $home
        <#
            Most of the standard PowerShell operators are supported in this syntax.
            This is restricted to accessing properties by name, and will not work
            for nested properties.
        #>
        $Folders = $Collection | Where-Object FullName -like '*a*'

        $Folders.Name | Select-Object -First 2 | Should -Be __
    }
}