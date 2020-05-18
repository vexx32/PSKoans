using module PSKoans
[Koan(Position = 112)]
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

    It 'can assign values to many variables at once' {
        $Var1 = $Var2 = $Var3 = $Var4 = __
        $Var1 | Should -Be $Var2
        $Var2 | Should -Be $Var3
        $Var3 | Should -Be $Var4
        $Var4 | Should -Be 27
    }

    It 'can assign multiple values to multiple variables' {
        $Var1, $Var2 = @( "__", "__")
        $Var1 | Should -Be "Correct"
        $Var2 | Should -Be "Incorrect"
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
            __ | Should -Be (13.7 + 4)
        }

        It 'can be used to concatenate strings' {
            'My name is ' + 'Jim' | Should -Be 'My name is Jim'
            __ | Should -Be ('hello' + 'world')
        }

        It 'can be used to put arrays together' {
            <#
                As we will cover in AboutArrays, this is not so much 'adding' arrays together as it is
                building a totally new array. It does, however, have its uses.
            #>
            $Array = 1, 2, 3, 4, 5
            $ExpectedResult = $Array + 7

            $Result = @(
                __
                __
                3
                __
                5
                __
            )
            $Result | Should -Be $ExpectedResult
        }

        It 'behaves according to the type of the left-hand item' {
            '____' | Should -Be ('10.5' + 11)

            __ | Should -Be (11 + '12.5')
            12.21 + 'FILL_ME_IN' -eq 23.43 | Should -BeTrue

            # Adding items into typed arrays will also cause the resulting value to be converted
            [int[]] $Array = @(1, 2, 3, 4, 5)
            $Array += '17'
            __ | Should -Be $Array
        }
    }
    Context 'Subtraction' {

        It 'works similarly to addition' {
            12 - 7 | Should -Be 5
            __ | Should -Be (11 - 3.5)
        }

        It 'cannot be used with strings' {
            { 'hello' - 'h' } | Should -Throw

            # However, this work if the string contains a useable number.
            __ | Should -Be ('12' - '7.5')

            # In other words, subtraction only operates on numerical values.
            { @(1, 2) - 1 } | Should -Throw -ExpectedMessage '____'
        }
    }

    Context 'Multiplication' {

        It 'can be used on both integer and non-integer numerals' {
            __ | Should -Be (12 * 4)
            12.1 * 2 | Should -Be 24.2
        }

        It 'can also be used on strings' {
            '____' | Should -Be ('A' * 4)
            '__' * 4 | Should -Be 'NANANANA'
        }
    }

    Context 'Division' {

        It 'is restricted to numeric use only' {
            <#
                As with subtraction, there's no useful meaning of using division on a string
                so any attempts to do so will throw an error.
            #>
            { 'hello!' / 3 } | Should -Throw -ExpectedMessage '____'

            <#
                Unlike with other numerical operators, however, division often results
                in a non-integer (double) value even when both operands are integers.
            #>
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
            $ModulusOnString = {
                # Some things are better seen when you try them for yourself.
                $String = 'hello!'
                $String % 4
            }
            # Only a partially matching phrase from the error message is necessary.
            $ModulusOnString | Should -Throw -ExpectedMessage '____'

            $ModulusOnArray = {
                # If you have trouble, try doing something similar in the console to see what happens.
                $Array = 1, 10, 20
                $Array % 4
            }
            $ModulusOnArray | Should -Throw -ExpectedMessage '____'
        }
    }
}

Describe 'Assignment/Arithmetic Combination Operators' {

    It 'is a bit unwieldy to assign and increment without combination operators' {
        $Value = 5

        $Value = $Value + 5
        __ | Should -Be $Value
    }

    It 'is possible to combine assignment and addition' {
        $Value = 12

        $Value += 7
        __ | Should -Be $Value
    }

    It 'is also possible to combine subtraction with assignment' {
        $Value = 19

        $Value -= 3
        __ | Should -Be $Value
    }

    It 'works the same way with division' {
        $Value = 16

        $Value /= 2
        __ | Should -Be $Value
    }

    It 'works with multiplication as well' {
        $Value = 8

        $Value *= 3
        __ | Should -Be $Value
    }

    It 'even works with modulus' {
        $Value = 12

        $Value %= 4
        __ | Should -Be $Value
    }

    It 'can get a bit confusing to follow' {
        $Value = __

        $Value /= 3
        $Value %= 5
        $Value += 4
        $Value *= 7
        $Value -= 7

        $Value | Should -Be 42
    }
}
