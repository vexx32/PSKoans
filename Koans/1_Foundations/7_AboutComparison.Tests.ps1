<#
    Comparison Operators

    Comparison operators are often used to compare two values. If the values
    satisfy the condition set by the operator, the expression returns $true;
    otherwise, it returns $false.

    Mathematical comparison operators are two letters preceded by a hyphen:
    -eq, -ne, -gt, -lt, -le, -ge

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
        It 'has a strict behaviour with most strings' {
            # Strings containing text behave a little differently in some cases
            'string' -eq 1 | Should -Be $false
            
            # How should strings cast to boolean?
            $true -eq 'Hello!' | Should -Be __ 
            
            # What about an empty string?
            $true -eq '' | Should -Be __ 
            
            # What about a string containing a number?
            $false -ne '0' | Should -Be __

            # In short: strings don't care about their contents when cast to boolean
            $true -eq 'False' | Should -Be __
        }
        It 'changes behaviour with arrays' {
            # Note that the array must always be on the left hand side of the comparison
            $Array = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

            $Array -eq 2 | Should -Be 2
            $Array -eq 11 | Should -Be $null
            $Array -ne 5 | Should -Be @(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
        }
    }
    Describe 'GreaterThan and LessThan' {
        It 'will compare values' {
            11 -gt 6 | Should -BeTrue
            __ -gt 14 | Should -BeTrue

            10 -lt 20 | Should -BeTrue
            __ -lt 0 | Should -BeTrue
        }
        It 'will often return many items from arrays' {
            $Array = 1, 5, 10, 15, 20, 25, 30

            $Array -gt 30 | Should -Be $null
            $Array -lt 10 | Should -Be @(1, 10)

        }
    }
    Describe 'GreaterOrEqual and LessOrEqual' {
        It 'is a combination of the above two types' {
            $Array = 1, 2, 3, 4, 5
            
            $Array -ge 3 | Should -Be @(3, 4, 5)
            $Array -le 2 | Should -Be @(1, 2, 3, 4)
            $Array -ge 5 | Should -Be __
        }
    }
}