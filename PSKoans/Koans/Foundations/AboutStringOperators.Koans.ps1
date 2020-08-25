using module PSKoans
[Koan(Position = 115)]
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

            $____ | Should -Be ($String -eq $OtherString)
            # Watch out for case sensitive operators!
            $____ | Should -Be ($String -ceq $OtherString)
        }

        It 'is useful for a straightforward comparison' {
            $String = 'one more string!'
            $OtherString = "ONE MORE STRING!"

            $____ | Should -Be ($String -ne $OtherString)
            $____ | Should -Be ($String -cne $OtherString)
        }
    }

    Context 'GreaterThan and LessThan' {

        It 'tells you where strings are in a sort' {
            $String = 'my string'
            $OtherString = 'your string'

            $____ | Should -Be ($String -gt $OtherString)
            $____ | Should -Be ($String -lt $OtherString)
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
            $Split = @(
                'hello'
                '____'
                'what'
                '____'
                '____'
                'day'
            )
            $Split | Should -Be ($String -split ' ')
        }

        It 'uses regex by default' {
            $String = 'hello.dear'
            # Since -split uses regex, we have to escape certain characters to treat them literally.
            @('____', '____') | Should -Be ($String -split '\.')
        }

        It 'can limit the number of substrings' {
            $Planets = 'Mercury,Venus,Earth,Mars,Jupiter,Saturn,Uranus,Neptune'
            @('____', '____', '____', '____') | Should -Be ($Planets -split ',', 4)
        }

        It 'can use simple matching' {
            $String = 'hello.dear'
            # Using SimpleMatch mode disables regex.
            @('____', '____') | Should -Be ($String -split '.', 0, 'SimpleMatch')
        }

        It 'can be case sensitive' {
            $String = "applesAareAtotallyAawesome!"
            @('____', '____', '____', '____') | Should -Be ($String -csplit 'A')
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
            '____' | Should -Be ($Array -join ' ')
        }

        It 'always produces a string result' {
            $Array = 1, 3, 6, 71, 9, 22, 1, 3, 4, 55, 6, 7, 8
            '____' | Should -Be (-join $Array)
        }

        It 'can join with any delimiters' {
            $Array = 'This', 'is', 'so', 'embarrassing!'
            $Array -join '____' | Should -Be 'This-OW! is-OW! so-OW! embarrassing!'
        }
    }

    Context 'Index Operator' {

        It 'lets you treat strings as [char[]] arrays' {
            $String = 'Beware the man-eating rabbit'

            '__' | Should -Be $String[5]
        }

        It 'can create a [char[]] array from a string' {
            $String = 'Good luck!'

            @('__', '__', '__', '__') | Should -Be $String[0..3]
        }

        It 'can be combined with -join to create substrings' {
            $String = 'Mountains are merely mountains.'

            '____' | Should -Be (-join $String[0..8])
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
            $String = '____'

            # -match automatically stores results in the $matches automatic variable for later use.
            $Result = if ($String -match '[a-z]{4}') {
                $Matches[0]
            }

            $Result | Should -Be '____'
        }

        It 'supports named matches' {
            $String = 'PowerShell is useful'
            $Pattern = '^(?<FirstWord>[a-z]+) [a-z]+ (?<LastWord>[a-z]+)$'

            $String -match $Pattern | Should -BeTrue

            $Matches.FirstWord | Should -BeExactly '____'
            $Matches.LastWord | Should -BeExactly '____'

            # Reflect on the above and below... can you find what that will match the pattern?
            $String = '____'
            $Pattern = '^(?<FirstWord>[a-z]+) (?<SecondWord>[a-z]+)$'

            $String -match $Pattern | Should -BeTrue -Because 'The string must match the given pattern.'

            $Matches.FirstWord | Should -BeExactly 'Cool'
            $Matches.SecondWord | Should -BeExactly 'Koans'
        }

        It 'supports indexed match groups' {
            <#
                When selecting match groups from unnamed groups, the first group is at index 1
                and the 'entire' matched portion is still at index 0
            #>
            $String = '1298-___-0000'
            $Pattern = '^([0-9]{4})-([0-5]{3})'
            $Result = $String -match $Pattern

            $Result | Should -BeTrue
            '__' | Should -Be $Matches[0]
            '1298' | Should -Be $Matches[1]
            '__' | Should -Be $Matches[2]
        }
    }

    Context 'Replace' {
        <#
            -replace also utilises regex to change the input string. Similarly to the string
            method .Replace($a,$b) it will replace every instance of the found pattern in the
            given string.
        #>
        It 'can be used to replace string segments' {
            $String = 'Keep calm and carry on.'
            $Pattern = 'and'
            $Replacement = '__'

            $String -replace $Pattern, $Replacement | Should -Be 'Keep calm & carry on.'
        }

        It 'can be used to remove specific characters' {
            $String = 'Polish the granite, boy!'
            $Pattern = '[aeiou]|[^a-z]'

            # By not providing a replacement string, the matching segments are removed.
            $String -replace $Pattern | Should -Be '__'
        }

        It 'can be used to isolate specific portions of a string' {
            $String = 'Account Number: 0281.3649.8123'
            $Pattern = '\w+ \w+: (\d{4})\.(\d{4})\.(\d{4})'
            # These tokens are Regex variables, not PS ones; literal strings or escaping is needed!
            $Replacement = '$1 $2 $3'

            '____' | Should -Be ($String -replace $Pattern, $Replacement)
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
            $Name = '____'

            '____' | Should -Be ($String -f $Name)
        }

        It 'can insert multiple values with formatting on each' {
            $String = 'Employee #{1:000000}, you are due in room #{0:000} for a drug test.'

            '____' | Should -Be ($String -f 154, 19)
        }
    }

    Context 'Subexpression Operator' {
        <#
            The subexpression operator $() is used to insert complex values into strings.
            Any valid PowerShell code is permitted inside the parentheses.
        #>
        It 'will convert any object to string' {
            $String = "Hello, user $(1..10)"

            '____' | Should -Be $String
        }

        It 'is necessary to insert object properties into strings' {
            $Object = Get-Item $Home

            '____' | Should -Be "$Object.Parent"
            '____' | Should -Be "$($Object.Parent)"
        }
    }
}
