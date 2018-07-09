<#
    Comparison Operators

    Comparison operators are often used to compare two values. If the values
    satisfy the condition set by the operator, the expression returns $true;
    otherwise, it returns $false.

    Most common comparison operators 

    It's important to remember that when working with arrays, this behaviour
    changes completely, as you will see shortly, and they instead return
    all items in the array that match the condition, or $null if no items
    satisfy the condition.
#>
Describe 'Comparison Operators' {
    Describe 'Equality and Inequality' {
        # The equality operator is '-eq', and inequality is '-ne'
        It 'is a simple test' {
            $true -eq $false | Should -Be $false
            1 -eq 1 | Should -Be __
        }
        It 'will attempt to convert types' {
            # Boolean values are considered the same as 0 or 1 in integer terms, and vice versa
            $true -eq 1 | Should -Be $true
            $false -ne 0 | Should -Be $false
            $true -eq 10 | Should -Be __ # What about higher numbers?
            -10 -eq $false | Should -Be __ # What about negative numbers?

            10 -ne 1 | Should -Be __

            # Strings and numbers will also be converted if possible
            '1' -eq 1 | Should -Be $true
            10 -eq '10' | Should -Be __
        }
    }
    Describe 'GreaterThan and LessThan' {

    }
    Describe 'GreaterThanOrEqual and LessThanOrEqual' {

    }
}