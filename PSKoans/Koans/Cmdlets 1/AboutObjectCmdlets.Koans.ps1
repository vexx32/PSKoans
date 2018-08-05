#Requires -Module PSKoans
[Koan(Position = 203)]
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

Describe 'Compare-Object' {
    <#
        Compare-Object is primarily for comparing collections of objects rather than individual
        items, and is usually used to display data comparisons to the user.
    #>
    It 'compares collections of objects' {
        $Comparison = @{
            ReferenceObject  = 'this', 'is', 'the', 'reference'
            DifferenceObject = 'these', 'is', 'the', 'difference'
        }
        $CompareData = Compare-Object @Comparison
        $CompareData[0].InputObject | Should -Be '__'
        $CompareData[0].SideIndicator | Should -Be '__'
        $CompareData[0] | Should -BeOfType __
    }

    It 'can display items that occur in both sets' {
        # By default, items that are the same in both collections are hidden.
        $Comparison = @{
            ReferenceObject  = 'this', 'is', 'the', 'reference'
            DifferenceObject = 'these', 'is', 'the', 'difference'
        }
        $CompareData = Compare-Object @Comparison -IncludeEqual
        $CompareData.SideIndicator -contains '==' | Should -BeTrue
        $CompareData.Where{$_.InputObject -eq 'the'}.SideIndicator | Should -Be '__'
    }
}

Describe 'Select-Object' {
    <#
        Select-Object is a utility cmdlet that is used to 'trim' objects down to just
        the 'selected' properties. It is particularly useful to get custom displays
        of data, and is capable of adding new properties as well.
    #>

    It 'selects specific properties of an object' {
        $File = New-TemporaryFile
        "Hello" | Set-Content -Path $File.FullName
        $File = Get-Item -Path $File.FullName

        $Selected = $File | Select-Object -Property Name, Length
        $Selected.PSObject.Properties.Name | Should -Be @('Name', '__')

        $Selected.Length | Should -Be __
    }

    It 'can exclude specific properties from an object' {
        $File = New-TemporaryFile

        $File.Attributes | Should -Be '__'

        $Object = $File | Select-Object -Property * -ExcludeProperty Attributes, Length

        $Object.Attributes | Should -Be $null
        $Object.Length | Should -Be __
    }

    It 'changes the object type' {
        $FileObject = Get-Item -Path $home

        $FileObject | Should -BeOfType __

        $Object = $FileObject | Select-Object -Property FullName, Name, DirectoryName
        $Object | Should -BeOfType __
    }

    It 'can retrieve just the contents or value of a property' {
        $FileObject = Get-Item -Path $home

        $FileName = $FileObject | Select-Object -ExpandProperty __ -ErrorAction SilentlyContinue

        $FileName | Should -Be $FileObject.Name
    }

    It 'can pick specific numbers of objects' {
        $Array = 1..100

        $FirstThreeValues = __
        $Array | Select-Object -First 3 | Should -Be $FirstThreeValues

        $LastFourValues = __
        $Array | Select-Object -Last 4 | Should -Be $LastFourValues

        $Array | Select-Object -Skip 10 -First 5 | Should -Be __
    }

    It 'can ignore duplicate objects' {
        $Array = 6, 1, 4, 8, 7, 5, 3, 9, 2, 3, 2, 1, 5, 1, 6, 2, 8, 4,
        7, 3, 1, 2, 6, 3, 7, 1, 4, 5, 2, 1, 3, 6, 2, 5, 1, 4

        $UniqueItems = 5, '__', 10, 9, '__', '__', '__', 7, '__', '__'
        $Array | Select-Object -Unique | Should -Be $UniqueItems
    }
}

Describe 'Where-Object' {

}

Describe 'ForEach-Object' {

}

Describe 'Tee-Object' {

}

Describe 'Group-Object' {

}

Describe 'Sort-Object' {

}
