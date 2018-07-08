. '$PSScriptRoot\Common.ps1'
<#
    Operators

    Just like many other programming languages, PowerShell has special operators designed to work with data.
    
    You can use the following command to get a full overview of how operators work:

        Get-Help about_Operators

    Loosely, operators fall into a few categories: assignment, arithmetic, comparison, redirection, and
    string operators.

    In terms of order of operations, arithmetic operators typically execute before comparison operators,
    followed by string operators, redirection operators, and finally assignment operators execute last.
#>
Describe 'Addition' {
    It 'is used to add two items together' {
        13 + 4 | Should -Be 17
        __ + 6 | Should -Be 13
        13.7 + 4 | Should -Be __
    }
    It 'can be used to concatenate strings' {
        # Be aware that it does not add any extra spacing, merely joins the exact strings.
        'hello' + 'world' | Should -Be __
        'My name is ' + 'Jim' | Should -Be 'My name is Jim'
    }
    It 'can be used to create arrays' {
        # As we covered in AboutArrays, this is not so much 'adding' arrays together as it is
        # building a totally new array. It does, however, have its uses.
        $Array = 1, 2, 3, 4, 5
        $NewArray = $Array + 7

        __ | Should -Be $NewArray
    }
    It 'behaves according to the type of the left-hand item' {
        '10.5' + 11 | Should -Be 21.5 # Shouldn't it? What do you think?
        # Interestingly, if the left type is numeric, an appropriate type will be chosen by
        # taking both operands into account
        
        11 + '12.5' | Should -Be __
        12.21 + 'FILL_ME_IN' -eq 23.43 | Should -BeTrue

        # Adding items into typed arrays will also cause the resulting value to be converted
        [int[]]@(1, 2, 3, 4, 5) + '17' | Should -Be __
    }
}
Describe 'Subtraction' {
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
Describe 'Multiplication' {
    It 'can be used on both integer and non-integer numerals' {
        12 * 4 | Should -Be __
        12.1 * 2 | Should -Be 24.2
    }
    It 'can also be used on strings' {
        'A' * 4 -eq 'FILL_ME_IN' | Should -BeTrue
        __ * 4 -eq "NANANANA" | Should -BeTrue
    }
}

Describe 'Comparison Operators' {

}
Describe 'String Operators' {

}
Describe 'Redirection Operators' {

}