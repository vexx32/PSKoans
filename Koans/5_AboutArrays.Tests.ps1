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

Describe "Arrays and Iterable Collections" {
    It "is useful for grouping related objects and values" {
        # The comma operator is used to create an array. Spaces are ignored, for the most part.
        $Ages = 12, 25, 18, 64
        <# 
            The array subexpression operator @() is used to create an array from multiple values
            or expressions. Within the parentheses, either commas, semicolons, or even line 
            breaks can be used to divide array elements. Although in many cases in PowerShell
            an expression that only returns one value will not become an array, this operator
            forces the value or object to be wrapped in an array.
        #> 
        $Names = @(
            "Steve"
            "John";"Jaime"
            "Abigail","Serena","Kali"
        )

        # Individual elements of an array can be accessed with square-bracket index syntax.
        # Arrays are zero-indexed; the first element is at index 0, the second at 1, etc.
        $Ages[0] | Should -Be 12
        $Ages[3] | Should -Be __
        $Names[4] | Should -Be __
    }
    It "allows the collection to be split into multiple parts" {

    }
}