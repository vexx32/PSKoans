using module PSKoans
[Koan(Position = 113)]
param()
<#
    Arrays and Iterable Collections

    Like many programming languages, PowerShell often uses arrays to keep
    collections of objects together. Arrays tie in closely with PowerShell's
    pipeline, which is one way to iterate over a collection with a good deal of
    efficiency.

    There are a few 'array-like' collection types available in PowerShell, all
    of which are rooted in .NET classes and data types, and behave much the same
    as they do in other .NET languages.

    Arrays in particular are closely tied to the PowerShell pipeline, which are
    covered in another topic.
#>
Describe 'Arrays' {

    It 'is useful for grouping related objects and values' {
        <#
            The comma operator is used to create an array.
            Spaces are typically ignored.
        #>
        $Ages = 12, 25, 18, 64

        <#
            Individual elements of an array can be accessed with square-bracket
            index syntax. Arrays are zero-indexed; the first element is at index
            [0], the second at [1], etc.
        #>
        $Ages[0] | Should -Be 12
        __ | Should -Be $Ages[3]
    }

    It 'can be created with the @() operator' {
        <#
            The array subexpression operator @() is used to create an array
            from multiple values or expressions. Within the parentheses, you can
            use commas, semicolons, or even line breaks to divide each element.
        #>
        $Names = @(
            'Steve'
            'John'; 'Jaime' # This is a messy way to do things, but it does work
            'Abigail', 'Serena', 'Kali'
            <#
                Having everything on its own line would be much cleaner and is a
                more common usage of this syntax.
            #>
        )

        # Where is index 4 in the above array?
        __ | Should -Be $Names[4]

        <#
            Although in many cases in PowerShell, an expression that only
            returns one value will not become an array, this operator forces the
            value or object to be wrapped in an array if the result is not
            already an array; it guarantes the result will be an array.
        #>
        $Array = @( 10 )

        $Array.GetType().FullName | Should -Be System.____
    }

    It 'is a fixed size collection; elements cannot be added or removed' {
        # Most arrays in PowerShell are fixed size. Elements cannot be directly added or removed.

        $Ages = 12, 25, 18, 64

        { $Ages.Add(59) } | Should -Throw -ExpectedMessage '____'
        { $Ages.Remove(12) } | Should -Throw -ExpectedMessage '____'
    }

    It 'can be created using the addition operator' {
        <#
            To add an element to a fixed size array, a new array must be
            created. PowerShell does this in the background when the addition
            operator is used.
        #>

        $Ages = 12, 25, 18, 64

        $Age = __
        $Ages = $Ages + $Age

        <#
            The operation above can be shortened using the addition and
            assignment combination operator.
        #>

        $Age = __
        $Ages += $Age

        $Ages | Should -Be 12, 25, 18, 64, 42, 59

        <#
            The cost of adding an element to an array in PowerShell like this
            increases with the size of the array.

            Each time a new element is added, the array must be copied to a new
            larger array to accommodate the new values.

            The result of the operation is another fixed size array.
        #>
    }

    It 'can be joined with another array using the addition operator' {
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
            If you know the contents of the array and want to skip specific
            elements, you can assign specific elements to $null to discard them.
            $null is one of PowerShell's automatic variable values, like $true
            and $false, and cannot be altered. Any data you attempt to assign to
            it will be ignored.
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

        # The List collection used above will be explored more in a later topic.
    }

    It 'allows use of negative indexes' {
        $Array = 1, 2, 3, 4, 5, 6, 7
        __ | Should -Be $Array[-1] # What is the -1th item?

        # Negative numbers can also form a range and extract subsets
        $Item = __
        @( $Item, 5, 6, 7) | Should -Be $Array[-4..-1]

        $Index = __
        $Array[-3, $Index, -6] | Should -Be @(5, 1, 2)
    }

    It 'can reverse an array' {
        $Array = 1, 2, 3, 4, 5, 6, 7
        $LastIndex = __
        $Array[-1..$LastIndex] | Should -Be @(7, 6, 5, 4, 3, 2, 1)
    }

    It 'does not throw exceptions with invalid indexes' {
        $Array = 1, 2, 3, 4

        # It allows negative indexes, but what about indexes out of range?
        __ | Should -Be $Array[4]

        # What about undefined negative indexes?
        __ | Should -Be $Array[-10]

        <#
            📝 NOTE

            The above will actually throw errors if you have PowerShell
            running in Strict Mode.
        #>
    }

    It 'can create be created from a range' {
        # The .. notation used to reverse an array can be used to copy an array.

        $Array = 1, 2, 3, 4, 5

        $StartIndex = __
        $StartIndex..5 | Should -Be $Array
    }

    It 'can create an array of letters from a range' {
        $firstLetter = '__'
        $lastLetter = '__'

        if ($PSVersionTable.PSEdition -eq 'Core') {
            # PowerShell 6.2+ can use .. between the letters to create an array.

            $letters = $firstLetter..$lastLetter

            $letters | Should -Be 'a', 'b', 'c', 'd'
        }
        else {
            <#
                Windows PowerShell 5 and below have to work a lot harder to
                achieve the same thing.
            #>

            $startIndex = [Int][Char]$firstLetter
            $endIndex = [Int][Char]$lastLetter
            $letters = ($startIndex)..($endIndex) -as [char[]]

            $letters | Should -Be 'a', 'b', 'c', 'd'
        }
    }

    It 'is usually of type Object[]' {
        <#
            Arrays in PowerShell are created with the type Object[]. Object is
            the parent type of all .NET objects, and the [] suffix denotes that
            the type represents an array containing multiple items of that type.
            You may also occasionally see things like int[,] which denotes a two
            dimensional array containing integers.

            In .NET, a child type can be "boxed" into its parent type and be
            treated the same (think of it like a child type being an add-on to
            the parent type; you can always cut away the additions and just work
            with the parent type if you really need to). Object is the sole
            parent type for all .NET objects, regardless of their type. As such,
            an array of type Object[] effectively has no restrictions on what
            can be inserted into one of its slots.
        #>

        $Numbers = 1, 2, 3, 4
        '____' | Should -Be $Numbers.GetType().Name

        $Strings = 'first', 'second', 'third'
        [____] | Should -Be $Strings.GetType()

        $Processes = Get-Process
        '____' | Should -Be $Processes.GetType().Name

        <#
            The base type of Object[], Char[], and other fixed size array types
            is the System.Array type, or [Array].

            The [Array] type describes the Length property (which is also
            aliased to Count in PowerShell), as well as other methods which can
            be used to work with the array.
        #>
    }

    It 'allows you to check if something is contained within it' {
        <#
            The available methods can be seen with Get-Member:

                Get-Member -InputObject @()

            For example, each array has a Contains method.
        #>
        $Numbers = 1, 2, 3, 4
        $____ -eq $Numbers.Contains(3) | Should -BeTrue

        # The Contains method is case sensitive for arrays containing strings.
        $Strings = 'first', 'second', 'third'
        $____ -eq $Strings.Contains('first') | Should -BeTrue
        $____ -eq $Strings.Contains('First') | Should -BeTrue
        # PowerShell's -contains operator is not case sensitive.
        $Strings -contains '____' | Should -BeTrue
        $Strings -contains '____' | Should -BeTrue
    }

    It 'can be cast to a specific collection type' {
        [string[]] $Array = 1, 2, 3, 4, 5

        # We started with numbers... what do we have after the array is created?
        [____] | Should -Be $Array[0].GetType()
        [____] | Should -Be $Array.GetType()
    }
}
