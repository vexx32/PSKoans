using module PSKoans
[Koan(Position = 105)]
param()
<#
    Arrays and Iterable Collections

    Like many programming languages, PowerShell often uses arrays to keep collections
    of objects together. Arrays tie in closely with PowerShell's pipeline, which
    is one way to iterate over a collection with a good deal of efficiency.

    There are a few 'array-like' collection types available in PowerShell, all
    of which are rooted in .NET classes and data types, and behave much the
    same as they do in C# and VB.NET.

    Arrays in particular have a close relationship with the PowerShell pipeline,
    which will be covered a shortly.
#>
Describe 'Arrays' {

    It 'is useful for grouping related objects and values' {
        # The comma operator is used to create an array. Spaces are typically ignored.
        $Ages = 12, 25, 18, 64

        # Individual elements of an array can be accessed with square-bracket index syntax.
        # Arrays are zero-indexed; the first element is at index 0, the second at 1, etc.
        $Ages[0] | Should -Be 12
        __ | Should -Be $Ages[3]

        <#
            The array subexpression operator @() is used to create an array from multiple values
            or expressions. Within the parentheses, either commas, semicolons, or even line
            breaks can be used to divide array elements. Although in many cases in PowerShell
            an expression that only returns one value will not become an array, this operator
            forces the value or object to be wrapped in an array.
        #>
        $Names = @(
            'Steve'
            'John'; 'Jaime' # This is a messy way to do things, but it does work
            'Abigail', 'Serena', 'Kali'
            # Having everything on its own line would be much cleaner and is a common usage of this syntax.
        )

        # Where is index 4 in the above array?
        __ | Should -Be $Names[4]
    }

    It 'allows the collection to be split into multiple parts' {
        $Ages = 11, 18, 25, 74, 19

        # An array can be split by assigning it to multiple variables at once:
        $Jim, $Ashley, $Theresa, $Bob, $Janice = $Ages

        $Jim | Should -Be 11
        __ | Should -Be $Bob

        # Arrays can be unevenly split by specifying fewer variables.
        $Jim, $Ashley, $Others = $Ages

        # What would be stored in $Others?
        __ | Should -Be $Others

        <#
            If you know the contents of the array and want to skip specific elements, you can
            assign specific elements to $null to discard them. $null is one of PowerShell's
            automatic variable values, like $true and $false, and cannot be altered. Any data
            you attempt to assign to it will be ignored.
        #>
        $null, $Number1, $Number2 = $Others
        __ | Should -Be $Number1
    }

    It 'lets you build a subset of the original array' {
        $Array = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        $Start = __
        $Finish = __

        # Arrays let you pick a range of indexes to build new arrays
        $Array[$Start..$Finish] | Should -Be @(6, 7, 8)

        # You can also select specific index numbers
        $Index = __
        $Array[1, $Index, 4] | Should -Be @(2, 9, 5)
    }

    It 'allows use of negative indexes' {
        $Array = 1, 2, 3, 4, 5, 6, 7
        __ | Should -Be $Array[-1] # What is the -1th item?

        # Negative numbers can also form a range and extract subsets
        $Array[-4..-1] | Should -Be @(5, 6, 7) # Is anything missing?
        $Index = __
        $Array[-3, $Index, -6] | Should -Be @(5, 1, 2)

        # You can make clever use of this to reverse an entire array!
        $LastIndex = __ # Hint: needs to be a negative number!
        $Array[-1..$LastIndex] | Should -Be @(7, 6, 5, 4, 3, 2, 1)
    }

    It 'does not throw exceptions with invalid indexes' {
        $Array = 1, 2, 3, 4

        # It allows negative indexes, but what about indexes out of range?
        __ | Should -Be $Array[4]

        # What about undefined negative indexes?
        __ | Should -Be $Array[-10]
    }
}
