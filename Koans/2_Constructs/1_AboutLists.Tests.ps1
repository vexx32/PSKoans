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
    It "can enforce strict typing on its contents" {        
        # New integer-only List
        $IntList = New-Object System.Collections.Generic.List[int]
        $IntList.Add(7)
        $IntList.Add(5.34)
        
        # Items are accessed by index just like arrays.
        $IntList[0] | Should -Be __
        $IntList[1] | Should -Be __

        $StringList = [System.Collections.Generic.List[string]]::new()
        $StringList.Add("FILL_ME_IN")
        $StringList.Add(12) # What happens if we add a number to a string-typed list?

        $StringList[0] | Should -Be "hello!"
        $StringList[1] | Should -Be __
    }
    It "can accept loose typing" {
        # We can cast convert an array. [object] or [PSObject] typed lists hold any type(s) of items.
        $List = [System.Collections.Generic.List[PSObject]]@(1, 2)

        # Items must be added to Lists using their .Add() or .AddRange() method.
        # .AddRange() takes an array or other collection object.
        $List.AddRange(@(12, 1, 2, 3))
        $List.Add(12.5)

        $List[0] | Should -Be __
        $List[6] -eq 12.5 | Should -Be $true
    }
    It "allows you to remove entries" {
        # Lists have a few methods for removing entries:
        # .Remove($value), .RemoveAt($Index) and .RemoveRange($Index,$Count) (among others)
        $List = [System.Collections.Generic.List[string]]@(12, 15, 15, 18, 'hello', 19, 4, 12, 5, 10)

        $List[3] | Should -Be '18'
        $List.RemoveAt(3)
        $List[3] | Should -Be '__'

        $List[1] | Should -Be '15'
        # The .Remove() method returns $true if the item was removed, and $false if it couldn't be
        # found or removed.
        $List.Remove('15') | Should -BeTrue
        $List[1] | Should -Be __

        # Now see if you can reduce the list down to only two values using the
        # .RemoveRange($Index, $Count) method
        # Feel free to add an additional ' | Should -Be ' test if you need it to guide your way!
        
        $List | Should -Be @('12', '10')
    }
}