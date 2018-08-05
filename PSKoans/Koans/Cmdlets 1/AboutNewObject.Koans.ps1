#Requires -Module PSKoans
[Koan(Position = 204)]
param()
<#
    *-Object Cmdlets

    There are 9 standard '-Object' cmdlets in PowerShell, each designed to work with, well,
    objects! They are, in no specific order: Compare-Object, ForEach-Object, Group-Object,
    Measure-Object, New-Object, Select-Object, Sort-Object, Tee-Object, and Where-Object.
#>
Describe 'New-Object' {

    It 'can create objects of a specified type' {
        $Object = New-Object -TypeName 'System.Collections.Hashtable'
        $Hashtable = @{}

        $Hashtable | Should -BeOfType System.Collections.Hashtable
        $Object | Should -BeOfType __
    }

    It 'can create objects of any available type' {
        $PSObject = New-Object -TypeName 'PSObject'
        $PSObject | Should -BeOfType __
    }

    It 'can accept arguments for the constructor' {
        $Object = New-Object 'string' -ArgumentList ([char[]]@('b','a','n','a','n','a'), 0, 3)
        '__' | Should -Be $Object
        $Object | Should -BeOfType string
    }

    It 'is just one way to instantiate an object' {
        $Object = New-Object 'PSObject'
        $Object2 = [PSObject]::new()

        $Object | Should -BeOfType System.Management.Automation.PSObject
        $Object2 | Should -BeOfType __
    }
}