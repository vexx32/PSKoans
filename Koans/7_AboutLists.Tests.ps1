. "$PSScriptRoot\Common.ps1"
<# 
    Lists - Flexible, Generic Collections

    Arrays have one critical weakness: they are immutable collections. While the
    members within them can change, the number of items they hold cannot. Consider the
    folllowing code:

    $Array = 0, 1
    $Array = $Array + 2
    $Array += 3

    # So, if the number of items in an array can't change, what happens here?
    # You might think it should fail with an error, but it won't!

    Actually, in PowerShell, the addition operator for arrays is defined something like:
    
        "Take the elements in this array, and the thing(s) we're adding in, and
        build a new array with them."

    This is very convenient, but it can create a problem - this gets significantly more
    expensive if you need to do it a lot. For large collections, adding items to them
    becomes very slow to do. 

    Introducing: Lists!

    Lists are generic collections, which means that they have a defined type when 
    created, and will only hold objects of that type. Other types will either be 
    converted, or cause an error to be thrown if there is no available conversion. 
    However, all objects in PowerShell inherit from [PSObject] or [object], so a 
    List with that typing will hold any mix of data types.

    There are several ways to create a List object, but we'll just cover the main
    methods. For more details, check out the available overloads, which you can
    see by executing the following line as-is in the PowerShell console:

    [System.Collections.Generic.List[psobject]]::new
#>

Describe "Lists" {
    It "has several types of enumerable collections that can be used" {
        
        
        # New Lists with no contents.
        $IntList = New-Object System.Collections.Generic.List[int]
        $StringList1 = [System.Collections.Generic.List[string]]::new()

        # Cast (converted) from existing array. [object] or [PSObject] typed lists hold any type of item.
        $List = [System.Collections.Generic.List[PSObject]]@(1, 2)

        # Items must be added to Lists using their .Add() or .AddRange() method.
        # .AddRange() takes an array or other collection object.
        $IntList.AddRange(@(12, 1, 2, 3))
        $StringList1.Add("__")
        $StringList1.Add(12) # What happens if we add a number to a string-typed list?
        $List.Add(12.5)

        # Items are accessed by index just like arrays.
        $StringList1[0] | Should -Be "Barry"
        $IntList[0] | Should -Be __
        $List[0] -eq 12.5 | Should -Be $true
    }
}