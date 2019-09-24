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

        <#
            Individual elements of an array can be accessed with square-bracket index syntax.
            Arrays are zero-indexed; the first element is at index 0, the second at 1, etc.
        #>
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

    It 'arrays are fixed size, elements cannot be added or removed' {
        # Most arrays in PowerShell are fixed size. Elements cannot be directly added or removed.

        $Ages = 12, 25, 18, 64

        { $Ages.Add(59) } | Should -Throw -ExpectedMessage '____'
        { $Ages.Remove(12) } | Should -Throw -ExpectedMessage 'Collection was of a fixed size.'
    }

    It 'new arrays are created using the addition operator' {
        <#
            To add an element to a fixed size array, a new array must be created. PowerShell does this
            in the background when the addition operator is used.
        #>

        $Age = __
        $Ages = $Ages + $Age

        # The operation above can be shortened using the Add-and-Assign operator.

        $Age = __
        $Ages += $Age

        $Ages | Should -Be 12, 25, 18, 64, 42, 59

        <#
            The cost of adding an element to an array in PowerShell like this increases with the
            size of the array.

            Each time a new element is added, the array must be copied to a new larger array to accommodate
            the new values.

            The result of the operation is another fixed size array.
        #>
    }

    It 'the addition operator can be used to join two arrays together' {
        $firstValue = __
        $fourthValue = __

        $Array = @($firstValue, 2) + @(3, $fourthValue)

        # A new array is created to hold all of the values.

        $Array | Should -Be 1, 2, 3, 4
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

    It 'has properties which describe the size of the array' {
        $Array = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

        __ | Should -Be $Array.Count

        # For fixed size arrays, the Count property is an alias of Length

        $Array.Count | Should -Be $Array.Length

        <#
            More advanced .NET collections do not have a Length property.
            Count is the more reliable choice.

            PowerShell adds the Count alias to fixed size arrays to make
            working with arrays and array-like collections consistent.
        #>

        $Array = 1, 2, 3, 4
        $List = [System.Collections.Generic.List[Int]]@(1, 2, 3, 4)

        $List.Count | Should -Be $Array.Count

        # The List collection used above is covered in more detail in a later Koan.
    }

    It 'allows use of negative indexes' {
        $Array = 1, 2, 3, 4, 5, 6, 7
        __ | Should -Be $Array[-1] # What is the -1th item?

        # Negative numbers can also form a range and extract subsets
        $Item = __
        @( $Item, 5, 6, 7) | Should -Be $Array[-4..-1]

        $Index = __
        $Array[-3, $Index, -6] | Should -Be @(5, 1, 2)

        # You can make use of this to reverse an entire array
        $LastIndex = __ # Hint: needs to be a negative number!
        $Array[-1..$LastIndex] | Should -Be @(7, 6, 5, 4, 3, 2, 1)
    }

    It 'does not throw exceptions with invalid indexes' {
        $Array = 1, 2, 3, 4

        # It allows negative indexes, but what about indexes out of range?
        __ | Should -Be $Array[4]

        # What about undefined negative indexes?
        __ | Should -Be $Array[-10]

        # NOTE: The above will actually throw errors if you have PowerShell running in Strict Mode.
    }

    It 'creates arrays from a range' {
        # The .. notation used to reverse an array may be used to array.

        $Array = 1, 2, 3, 4, 5

        __..5 | Should -Be $Array
    }

    It 'an array of letters may be created from a range' {
        # An array of characters, or letters, can be created.

        $firstLetter = '____'
        $lastLetter = '____'

        if ($PSVersionTable.PSEdition -eq 'Core') {
            # PowerShell Core uses .. between the letters to create an array.

            $letters = $firstLetter..$lastLetter

            $letters | Should -Be 'a', 'b', 'c', 'd'
        }
        else {
            # Windows PowerShell 5 and below have to work a lot harder to achieve the same thing.

            $letters = [Int][Char]$firstLetter..[Int][Char]$lastLetter -as [Char[]]

            $letters | Should -Be 'a', 'b', 'c', 'd'
        }
    }

    It 'Object[] and the Array type' {
        <#
            Arrays in PowerShell are created with the type Object[]. An array of Objects.

            The Object type can hold anything at all. A numeric value, a character, a Process, and so on.
        #>

        $Numbers = 1, 2, 3, 4
        $Numbers.GetType().Name | Should -Be 'Object[]'

        $Strings = 'first', 'second', 'third'
        $Strings.GetType().Name | Should -Be 'Object[]'

        $Processes = Get-Process
        $Processes.GetType().Name | Should -Be 'Object[]'

        <#
            The base type of Object[], Char[], and other fixed size array types is the System.Array
            type, or [Array].

            The [Array] type describes the Length property (aliased to Count), as well as other methods
            which can be used to work with the array.

            The available methods can be seen with Get-Member:

                Get-Member -InputObject @()

            For example, each array has a Contains method.
        #>

        $Numbers.Contains(3) | Should -BeTrue

        # The Contains method is case sensitive for arrays containing strings.

        $Strings.Contains('first') | Should -BeTrue
        $Strings.Contains('First') | Should -BeFalse

        # PowerShell's -contains operator is not case sensitive.

        $Strings -contains 'first' | Should -BeTrue
        $Strings -contains 'First' | Should -BeTrue
    }
}
