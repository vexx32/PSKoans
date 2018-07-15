<#
    String Operators

    While the standard comparison operators can be used with strings, there are also
    several operators that work exclusively with strings.

    The string operators are below:

    Operator            Name                        Purpose
    --------            ----                        -------
    -eq, -ne            Equal, Not Equal            Compare string
    -gt, -lt            GreaterThan, LessThan       Compare string sort order
    -ge, -le            Greater/LessOrEqual         Compare string sort order
    -f                  Format                      Insert and format variables/expressions
    [ ]                 Index                       Access characters in string
    $( )                Subexpression               Insert complex expressions into string
    -join               Join                        Join string array into single string
    -replace            Replace                     Regex: replace characters
    -split              Split                       Regex: split string into array
    -match, -notmatch   Match, Notmatch             Regex: compare string with regex expression
#>

Describe 'String Comparison Operators' {
    <#
        String comparisons work a bit differently to other comparisons. Rather than comparing
        the value of data, the strings are sorted, and the result of the sort determines
        whether a given comparison returns $true.

        In other words, 'ab' -lt 'bc'  is $true because the first string comes before the
        second in a simple ascending sort). -eq and -ne work basically as expected.

        Unless specified, all operators are case-insensitive. To make a given operator
        case sensitive, prefix it with 'c' (e.g., -ceq, -creplace, -cmatch)
    #>
    Context 'Equals and NotEquals' {

        It 'tells you whether strings are the same' {
            $String = 'this is a string.'
            $OtherString = 'This is a string.'

            $String -eq $OtherString | Should -Be __
            # Watch out for case sensitive operators!
            $String -ceq $OtherString | Should -Be __
        }

        It 'is useful for a straightforward comparison' {
            $String = 'one more string!'
            $OtherString = "ONE MORE STRING!"

            $String -ne $OtherString | Should -Be __
            $String -cne $OtherString | Should -Be __
        }
    }

    Context 'GreaterThan and LessThan' {

        It 'tells you where strings are in a sort' {
            $String = 'my string'
            $OtherString = 'your string'

            $String -gt $OtherString | Should -Be __
            $String -lt $OtherString | Should -Be __
        }
    }
}

Describe 'String Array Operators' {

    Context 'Split Operator' {
        <#
            The -split operator is used to break a longer string into several smaller strings.
            It can utilise either a regex match or a simple string character match, but
            defaults to regex.

            There are several formats for -split:
                $string -split $chars, 0, 'simplematch'
                $string -split $pattern
                $string -split $pattern, $MaxSubstrings
                -split $pattern
        #>
        It 'can split one string into several' {
            $String = "hello fellows what a lovely day"
            $String -split ' ' | Should -Be @(
                'hello'
                '__'
                'what'
                '__'
                '__'
                'day'
            )
        }

        It 'uses regex by default' {
            $String = 'hello.dear'
            $String -split '.' | Should -Be @('__', '__')
        }

        It 'can use simple matching' {
            $String = 'hello.dear'
            $String -split '.', 0, 'simplematch' | Should -Be @('__', '__')
        }

        It 'can limit the number of substrings' {
            $Planets = 'Mercury,Venus,Earth,Mars,Jupiter,Saturn,Uranus,Neptune'
            $Planets -split ',', 4 | Should -Be @('__', '__', '__', '__')
        }

        It 'can be case sensitive' {
            $String = "applesAareAtotallyAawesome!"
            $String -csplit 'A' | Should -Be @('__', '__', '__', '__')
        }
    }

    Context 'Join Operator' {
        <#
            -join is used to splice an array of strings together, optionally with a separator
            character. It comes in two forms,
        #>
    }
}

Describe 'Regex Operators' {

}

Describe 'Formatting Operators' {

}