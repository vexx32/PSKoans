#Requires -Module PSKoans
[Koan(204)]
param()
<#
    *-Object Cmdlets

    There are 9 standard '-Object' cmdlets in PowerShell, each designed to work with, well,
    objects! They are, in no specific order: Compare-Object, ForEach-Object, Group-Object,
    Measure-Object, New-Object, Select-Object, Sort-Object, Tee-Object, and Where-Object.
#>
Context 'Non-Pipeline Cmdlets' {

    Describe 'New-Object' {

        It 'can create objects of a specified type' {
            $Object = New-Object -TypeName 'string'
            $String = 'string'

            $String | Should -BeOfType string
            $Object | Should -BeOfType __
        }

        It 'can create objects of any available type' {
            $Object = New-Object -TypeName 'System.Collections.ArrayList'
            $Object | Should -BeOfType __
        }

        It 'can accept arguments for the constructor' {
            $Object = New-Object 'string' -ArgumentList ([char[]]@('b','a','n','a','n','a'), 0, 3)
            '__' | Should -Be $Object
            $Object | Should -BeOfType string
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
}

Context 'Pipeline Cmdlets' {

    Describe 'Select-Object' {

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
}