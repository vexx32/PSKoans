using module PSKoans
[Koan(Position = 304)]
param()

<#
    PSObjects

    Everything in PowerShell is in actuality a PSObject. PSObject is a wrapper type that can contain
    any other type of boxable object, or none. Not all object types can actually be boxed; byref-like
    structs (e.g., System.Span) are one particular example.

    PSObjects can be used to add additional members to a basic object type; this is how the Add-Member
    cmdlet works. It is also quite easy to access the normally-hidden PSObject properties in order
    to accomplish otherwise difficult tasks, such as dynamically listing any given object's members,
    as well as adding and removing ETS (instance) properties.

    It is somewhat comparable to C#'s ExpandoObject, but is unrelated.
#>

Describe 'PSObject' {
    BeforeAll {
        $Object = @('Stand for nothing; fall for everything.')
    }

    It 'is accessed via a hidden .PSObject property' {
        <#
            The .PSObject member contains many properties, but the .PSObject property itself does not
            actually tab-complete, though its child properties do.
        #>
        $PSObjectProperties = ($Object.PSObject | Get-Member -MemberType Properties).Name

        @(
            'BaseObject'
            '__'
            'Members'
            'Methods'
            '__'
            '__'
        ) | Should -Be $PSObjectProperties
    }

    It 'details the base object properties and methods' {
        $PropertyNames = @(
            __
            'LongLength'
            __
            'SyncRoot'
            __
            'IsFixedSize'
            __
            'Count'
        )
        $PropertyNames | Should -Be $Object.PSObject.Properties.Name

        $Methods = $Object.PSObject.Methods
        __ | Should -Be $Methods.Count
        $Methods['__'].Name | Should -Be 'Length'
    }
}