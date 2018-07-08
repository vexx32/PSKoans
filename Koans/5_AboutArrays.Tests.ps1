<#
    Arrays and Iterable Collections

    Like many programming languages, PowerShell often arrays to keep collections
    of objects together. Arrays tie in closely with PowerShell's pipeline, which
    is one way to iterate over a collection with a good deal of efficiency.

    There are a few 'array-like' collection types available in PowerShell, all
    of which are rooted in .NET classes and data types, and behave much the 
    same as they do in C# and VB.NET.

    Arrays in particular have a close relationship with the PowerShell pipeline,
    which will be covered in the next set of koans.
#>

Describe "Arrays and Enumerable Collections" {
    It "is useful for grouping related objects and values" {
        # The comma operator is used to create an array. Spaces are ignored, for the most part.
        $Ages = 12, 25, 18, 64

        # Individual elements of an array can be accessed with square-bracket index syntax.
        # Arrays are zero-indexed; the first element is at index 0, the second at 1, etc.
        $Ages[0] | Should -Be 12
        $Ages[3] | Should -Be __
        <# 
            The array subexpression operator @() is used to create an array from multiple values
            or expressions. Within the parentheses, either commas, semicolons, or even line 
            breaks can be used to divide array elements. Although in many cases in PowerShell
            an expression that only returns one value will not become an array, this operator
            forces the value or object to be wrapped in an array.
        #> 
        $Names = @(
            "Steve"
            "John";"Jaime" # This is a messy way to do things, but it does work
            "Abigail", "Serena", "Kali"
            # Having everything on its own line would be much cleaner and is a common usage of this syntax.
        )
        # Where is index 4 in the above array?
        $Names[4] | Should -Be __
    }
    It "allows the collection to be split into multiple parts" {
        $Ages = 11, 18, 25, 74, 19
        # An array can be split by assigning it to multiple variables at once:
        $Jim, $Ashley, $Theresa, $Bob, $Janice = $Ages

        $Jim | Should -Be 11
        $Bob | Should -Be __

        # Arrays can be unevenly split by specifying fewer variables.
        $Jim, $Ashley, $Others = $Ages
        # What would be stored in $Others?
        $Others | Should -Be __
        <# 
            If you know the contents of the array and want to skip specific elements, you can
            assign specific elements to $null to discard them. $null is one of PowerShell's 
            automatic variable values, like $true and $false, and cannot be altered. Any data
            you attempt to assign to it will be ignored.
        #>
        $null, $Number1, $Number2 = $Others
        $Number1 | Should -Be __
    }
    It "has several types of enumerable collections that can be used" {
        <# 
            Arrays have one critical weakness: they are immutable collections. While the
            members within them can change, the number of items they hold cannot.
        #>
        $Array = 0, 1
        $Array = $Array + 2
        $Array += 3

        # So, if the number of items in an array can't change, what happens here?
        # You might think it should fail with an error, but it won't!

        $Array | Should -Be __ # So what is it? What happens?
        <#
            Actually, in PowerShell, the addition operator for arrays is defined something like:
                "Take the elements in this array, and the thing(s) we're adding in, and
                build a new array with them."

            This is very convenient, but it can create a problem - this gets significantly more
            expensive if you need to do it a lot. For large collections, adding items to them
            becomes very slow to do. 

            In these cases, we have a few .NET collection types that perform much better.
            Introducing: Lists!
        #>
        # These methods of defining a list have largely the same results.
        $List1 = New-Object System.Collections.Generic.List[int] # Slow but very clear in intent
        
        # New List with no contents
        $List2a = [System.Collections.Generic.List[string]]::new() 
        # New List with 3 empty elements
        $List2b = [System.Collections.Generic.List[string]]::new(3) 
        # New List with whatever was in the array transferred into the List
        $List2c = [System.Collections.Generic.List[string]]::new(@(1, 2))

        # Cast from array. Identical method to $List2c.
        $List3a = [System.Collections.Generic.List[double]]@(1, 2)
        [System.Collections.Generic.List[double]]$List3b = @(1, 2)
    }
}