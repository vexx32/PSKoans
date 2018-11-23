using module PSKoans
[Koan(Position = 106)]
param()
<#
    Assignment and Arithmetic Operators

    Just like many other programming languages, PowerShell has special operators designed to
    work with data.

    You can use the following command to get a full overview of how operators work:

        Get-Help about_Operators

    Loosely, operators fall into a few categories: assignment (=), arithmetic, comparison,
    redirection, and string operators.

    In terms of order of operations, arithmetic operators typically execute before
    comparison operators, followed by string operators, redirection operators, and finally
    assignment operators execute last.
#>
Describe 'Assignment Operator' {

    It 'is used to assign a value to variables' {
        $ExpectedValue = 1 + 1
        $ActualValue = __

        $ActualValue | Should -Be $ExpectedValue
    }

    It 'is also used to assign a value to properties or elements' {
        # With arrays, we can assign values directly to indexes
        $Array = 1, 2, 3
        $Array[2] = 5
        $Array | Should -Be @(1, 2, 3) # What would change?
    }
}

Describe 'Arithmetic Operators' {
    <#
        These can be used for standard arithmetic with numerical values, as well as some limited
        usage with arrays and strings that can come in handy.
    #>
    Context 'Addition' {

        It 'is used to add two items together' {
            13 + 4 | Should -Be 17
            __ + 6 | Should -Be 13
            13.7 + 4 | Should -Be __
        }

        It 'can be used to concatenate strings' {
            'hello' + 'world' | Should -Be __
            'My name is ' + 'Jim' | Should -Be 'My name is Jim'
        }

        It 'can be used to create arrays' {
            <#
                As we covered in AboutArrays, this is not so much 'adding' arrays together as it is
                building a totally new array. It does, however, have its uses.
            #>
            $Array = 1, 2, 3, 4, 5
            $NewArray = $Array + 7

            # Match the input with what's actually in $NewArray!
            1, 2, 3, 4, 5, 6, 7, 8 | Should -Be $NewArray
        }

        It 'behaves according to the type of the left-hand item' {
            '10.5' + 11 | Should -Be 21.5 # Or should it?

            11 + '12.5' | Should -Be __
            12.21 + 'FILL_ME_IN' -eq 23.43 | Should -BeTrue

            # Adding items into typed arrays will also cause the resulting value to be converted
            [int[]]@(1, 2, 3, 4, 5) + '17' | Should -Be __
        }
    }
    Context 'Subtraction' {

        It 'works similarly to addition' {
            12 - 7 | Should -Be 5
            11 - 3.5 | Should -Be __
        }

        It 'cannot be used with strings' {
            {'hello' - 'h'} | Should -Throw

            # Except, of course, when the string contains a useable number.
            '12' - '7.5' | Should -Be __

            # In other words, subtraction only operates on numerical values.
            {@(1, 2) - 1} | Should -Throw
        }
    }

    Context 'Multiplication' {

        It 'can be used on both integer and non-integer numerals' {
            12 * 4 | Should -Be __
            12.1 * 2 | Should -Be 24.2
        }

        It 'can also be used on strings' {
            'A' * 4 -eq 'FILL_ME_IN' | Should -BeTrue
            __ * 4 -eq 'NANANANA' | Should -BeTrue
        }
    }

    Context 'Division' {

        It 'is restricted to numeric use only' {
            # As with subtraction, there's no useful meaning of using division on a string
            # so any attempts to do so will throw an error.
            {'hello!' / 3} | Should -Throw

            # Unlike with other numerical operators, however, division often results
            # in a non-integer (double) value even when both operands are integers.
            3 / 4 | Should -Be 0.75
            __ / 10 -eq 0.5 | Should -BeTrue
        }
    }

    Context 'Modulus' {

        # Modulus is a bit of an odd one, but common enough in programming. It performs a
        # division, and then returns the integer value of the remainder.
        It 'is usually used with integers' {
            $Remainder = 15 % 7
            __ | Should -Be $Remainder
        }

        It 'cannot be used on non-numeric values' {
            {
                $String = 'hello!'
                $String % 4
            }  | Should -Throw -ExpectedMessage __
            {
                $Array = 1, 10, 20
                $Array % 4
            } | Should -Throw -ExpectedMessage __
        }
    }
}

Describe 'Assignment/Arithmetic Combination Operators' {

    It 'can be used to simplify expressions' {
        # With only assignment and arithmetic, some expressions can get a bit unwieldy
        $Value = 5
        $Value = $Value + 5
        $Value | Should -Be 10

        # We can combine the two to increment or decrement a variable!
        $Value = 12
        $Value += 7
        $Value | Should -Be 19

        $Value -= 3
        $Value | Should -Be __

        # We can even combine multiplication and division with assignment
        $Value /= 2
        $Value | Should -Be 8

        $Value *= 3
        $Value | Should -Be __

        # Modulus hasn't been left out, either.
        $Value = 12
        $Value %= 4
        $Value | Should -Be __
    }
}