. "$PSScriptRoot\Common.ps1"
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
}