using module PSKoans
[Koan(Position = 109)]
param()
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

    See 'Get-Help about_Operators' for more information.
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

            __ | Should -Be ($String -eq $OtherString)
            # Watch out for case sensitive operators!
            __ | Should -Be ($String -ceq $OtherString)
        }

        It 'is useful for a straightforward comparison' {
            $String = 'one more string!'
            $OtherString = "ONE MORE STRING!"

            __ | Should -Be ($String -ne $OtherString)
            __ | Should -Be ($String -cne $OtherString)
        }
    }

    Context 'GreaterThan and LessThan' {

        It 'tells you where strings are in a sort' {
            $String = 'my string'
            $OtherString = 'your string'

            __ | Should -Be ($String -gt $OtherString)
            __ | Should -Be ($String -lt $OtherString)
        }
    }
}

Describe 'String Array Operators' {

    Context 'Split Operator' {
        <#
            The -split operator is used to break a longer string into several smaller strings.
            It can utilise either a regex match or a simple string character match, but
            defaults to regex.

            See 'Get-Help about_Split' for more information.
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
            $String -split '\.' | Should -Be @('__', '__')
        }

        It 'can limit the number of substrings' {
            $Planets = 'Mercury,Venus,Earth,Mars,Jupiter,Saturn,Uranus,Neptune'
            $Planets -split ',', 4 | Should -Be @('__', '__', '__', '__')
        }

        It 'can use simple matching' {
            $String = 'hello.dear'
            $String -split '.', 0, 'simplematch' | Should -Be @('__', '__')
        }

        It 'can be case sensitive' {
            $String = "applesAareAtotallyAawesome!"
            $String -csplit 'A' | Should -Be @('__', '__', '__', '__')
        }
    }

    Context 'Join Operator' {
        <#
            -join is used to splice an array of strings together, optionally with a separator
            character. It comes in standard and unary forms:

                'string', 'string2' -join ' ' -> string string2
                -join ('string','string2') -> stringstring2

            See 'Get-Help about_Join' for more information.
        #>
        It 'can join an array into a single string' {
            $Array = 'Hi', 'there,', 'what', 'are', 'you', 'doing?'
            $Array -join ' ' | Should -Be '__'
        }

        It 'always produces a string result' {
            $Array = 1, 3, 6, 71, 9, 22, 1, 3, 4, 55, 6, 7, 8
            -join $Array | Should -Be '__'
        }

        It 'can join with any delimiters' {
            $Array = 'This', 'is', 'so', 'embarrassing!'
            $Array -join '__' | Should -Be 'This-OW! is-OW! so-OW! embarrassing!'
        }
    }

    Context 'Index Operator' {

        It 'lets you treat strings as [char[]] arrays' {
            $String = 'Beware the man-eating rabbit'

            $String[5] | Should -Be '__'
        }

        It 'can create a [char[]] array from a string' {
            $String = 'Good luck!'

            $String[0..3] | Should -Be @('__', '__', '__', '__')
        }

        It 'can be combined with -join to create substrings' {
            $String = 'Mountains are merely mountains.'

            -join $String[0..8] | Should -Be '__'
        }
    }
}

Describe 'Regex Operators' {
    <#
        Regex is a very complex language that doesn't read well. The examples here will be
        fairly straightforward. If you are not already familiar with regex, check out
        https://regexr.com/ and play around with the example patterns given, and try some of
        your own.

        In this section, try to enter a string that matches the given pattern, using
        the explanations of each pattern on the website above!
    #>
    Context 'Match and NotMatch' {
        # These operators return either $true or $false, indicating whether the string matched.

        It 'can be used as a simple conditional' {
            $String = '__'

            $String -match '[a-z]' | Should -BeTrue
            $String -notmatch '[xfd]' | Should -BeTrue
        }

        It 'can store the matched portions' {
            $String = '__'

            $Result = if ($String -match '[a-z]{4}') {
                $Matches[0]
            }

            $Result | Should -Be '__'
        }

        It 'supports named matches' {
            # Regex uses the (?<NAME>$pattern) syntax to name a portion of a matched string
            $String = '__'
            $Pattern = '^(?<FirstWord>[a-z]+) (?<SecondWord>[a-z]+)$'

            $String -match $Pattern | Should -BeTrue

            $Matches.FirstWord | Should -Be '__'
            $Matches.SecondWord | Should -Be '__'
        }

        It 'supports indexed match groups' {
            # When selecting match groups from unnamed groups, the first group is at index 1
            # and the 'entire' matched portion is still at index 0
            $String = '1298-___-0000'
            $Pattern = '^([0-9]{4})-([0-5]{3})'
            $Result = $String -match $Pattern

            $Result | Should -BeTrue
            $Matches[0] | Should -Be '__'
            $Matches[1] | Should -Be '1298'
            $Matches[2] | Should -Be '__'

        }
    }

    Context 'Replace' {
        <#
            -replace also utilises regex to change the input string. Similarly to the string
            method .Replace($a,$b) it will replace every instance of the found pattern in the
            given string.
        #>
        It 'can be used to replace individual characters' {
            $String = 'Keep calm and carry on.'
            $Pattern = 'and'
            $Replacement = '__'

            $String -replace $Pattern, $Replacement | Should -Be 'Keep calm & carry on.'
        }

        It 'can be used to remove specific characters' {
            $String = 'Polish the granite, boy!'
            $Pattern = '[aeiou]|[^a-z]'

            $String -replace $Pattern | Should -Be '__'
        }

        It 'can be used to isolate specific portions of a string' {
            $String = 'Account Number: 0281.3649.8123'
            $Pattern = '\w+ \w+: (\d{4})\.(\d{4})\.(\d{4})'
            # These tokens are Regex variables, not PS ones; literal strings or escaping needed!
            $Replacement = '$1 $2 $3'

            $String -replace $Pattern, $Replacement | Should -Be '__'
        }
    }
}

Describe 'Formatting Operators' {

    Context 'String Format Operator' {
        <#
            The format operator (-f) uses the same formatting parser as the .NET method
            [string]::Format(), allowing for more complex strings to be constructed in
            a clear and concise fashion.
        #>
        It 'allows you to insert values into a literal string' {
            $String = 'Hello {0}, my name is also {0}!'
            $Name = '__'

            $String -f $Name | Should -Be '__'
        }

        It 'can insert multiple values with formatting on each' {
            $String = 'Employee #{1:000000}, you are due in room #{0:000} for a drug test.'

            $String -f 154, 19 | Should -Be '__'
        }
    }

    Context 'Subexpression Operator' {
        <#
            The subexpression operator $() is used to insert complex values into strings.
            Any valid PowerShell code is permitted inside the parentheses.
        #>
        It 'will convert any object to string' {
            $String = "Hello, user $(1..10)"

            $String | Should -Be '__'
        }

        It 'is necessary to insert object properties into strings' {
            $Object = Get-Item $Home

            "$Object.Parent" | Should -Be '__'
            "$($Object.Parent)" | Should -Be '__'
        }
    }
}
