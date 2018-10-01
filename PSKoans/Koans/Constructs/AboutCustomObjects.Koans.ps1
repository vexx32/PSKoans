#Requires -Modules PSKoans
[Koan(Position = 303)]
param()
<#
    Custom Objects

    PowerShell often makes extensive use of custom objects. Similar in usage to ExpandoObject for C#,
    powershell's PSObject wrapper allows almost any object to be given additional properties. These
    differ from their base type properties and are often in the form of NoteProperties and
    ScriptProperties.

    NoteProperties can store any value or reference to another object, permitting nested objects and
    effectively mirroring any static property as you might find on a defined class, but can be easily
    added to a new object without needing to define a class.

    ScriptProperties are defined as a script block value. Upon retrieving the value, the script block
    is evaluated, with the final value of the ScriptProperty being resolved on the completion of the
    script block.
#>
Describe '[PSCustomObject]' {

    It 'can be built from a hashtable' {
        <#
            This behaves like a cast, but it's actually a bit different. A directly-cast hashtable
            preserves the order of the elements, unlike regular hashtables, thanks to some parser
            magic.
        #>
        $Object = [PSCustomObject]@{
            Property = 'Value'
        }
        $Object | Should -BeOfType PSCustomObject
    }

    It 'can be built by trimming objects down' {
        $Object = Get-ChildItem -Path $Home | Select-Object -First 1 -Property Name, Parent
        $Object | Should -BeOfType PSCustomObject
        __ | Should -Be $Object.Parent.Name
    }

    It 'can have arbitrary properties' {
        $Object = [PSCustomObject]@{ '__' = 'Enter Property Name' }
        }

        __ | Should -Be $Object.PSObject.Properties.Count
        __.PSObject.Properties.Name | Should -Be 'PropertyName'
    }

    It 'can be added to' {
        $Object = [PSCustomObject]@{ 'Property1' = 12 }
        $Object | Add-Member -MemberType NoteProperty -Name 'Property2' -Value __

        $Object.Property2 | Should -Be $($Object.Property1 - 7)
    }

    It 'can have ScriptProperties' {

    }
}