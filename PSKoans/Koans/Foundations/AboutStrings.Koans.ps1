using module PSKoans
[Koan(Position = 108)]
param()
<#
    Strings

    Strings in PowerShell come in two flavours: standard strings, and string literals.
    Standard strings in PoSH are created using double-quotes, whereas string literals
    are created with single quotes.

    Unlike most other languages, standard strings in PowerShell are not literal and
    can evaluate expressions or variables mid-string in order to dynamically insert
    values into a preset string.
#>
Describe 'Strings' {

    It 'is a simple string of text' {
        __ | Should -Be 'string'
    }

    Context 'Literal Strings' {

        It 'assumes everything is literal' {
            $var = 'Some things you must take literally'
            __ | Should -Be $var
        }

        It 'can contain special characters' {
            # 'Special' is just a title.
            $complexVar = 'They have $ or : or ; or _'
            $complexVar | Should be '__'
        }

        It 'can contain quotation marks' {
            $Quotes = 'These are ''quotation marks'' you see?'

            # Single quotes go more easily in double-quoted strings.
            $Quotes | Should -Be "__"
        }
    }

    Context 'Evaluated Strings' {

        It 'can expand variables' {
            $var = 'apple'
            '__' | Should -Be "My favorite fruit is $var"
        }

        It 'can do a simple expansion' {
            '__' | Should -Be "Your home directory is located here: $HOME"
        }

        It 'handles other ways of doing the same thing' {
            # Strings can handle entire subexpressions being inserted as well!
            $String = "Your home folder is: $(Get-Item $HOME)"
            '__' | Should -Be $String
        }

        It 'can escape special characters with backticks' {
            $LetterA = 'Apple'
            $String = "`$LetterA contains $LetterA."

            '__' | Should -Be $String
        }

        It 'can escape quotation marks' {
            $String = "This is a `"string`" value."
            $AlternateString = "This is a ""string"" value."

            # A mirror image, a familiar pattern, reflected in the glass.
            $String, $AlternateString | Should -Be @('__', '__')
        }

        It 'can insert special characters with escape sequences' {
            <#
                All text strings in PowerShell are actually just a series of character values. Each of these values
                has a specific number assigned in the [char] type that represents that letter, number, space, symbol,
                etc.

                .NET uses UTF16 encoding for [char] and [string] values. However, with most common letters, numbers,
                and symbols the assigned [char] values are identical to the ASCII values.

                ASCII is an older standard encoding for text, but you can still use all those values as-is with
                [char] and get back what you'd expect thanks to the design of the UTF16 encoding. An extended ASCII
                code table is available at: https://www.ascii-code.com/
            #>
            $ExpectedValue = [char] 9

            <#
                If you're not sure what character you're after, consult the ASCII code table above.

                Get-Help about_Special_Characters will list the escape sequence you can use to create
                the right character with PowerShell's native string escape sequences.
            #>
            $ActualValue = "`_"

            $ActualValue | Should -Be $ExpectedValue
        }
    }

    Context 'String Concatenation' {

        It 'adds strings together' {
            # Two become one.
            $String1 = 'This string'
            $String2 = 'is cool.'

            $String1 + ' ' + $String2 | Should -Be 'This string is cool.'
        }

        It 'can be done simpler' {
            # Water mixes seamlessly with itself.
            $String1 = 'This string'
            $String2 = 'is cool.'

            "$String1 __" | Should -Be 'This string is cool.'
        }
    }

    Context 'Substrings' {

        It 'lets you select portions of a string' {
            # Few things require the entirety of the library.
            $String = 'At the very top!'

            '__' | Should -Be $String.Substring(0, 6)
            '__' | Should -Be $String.Substring(7)
        }
    }

    Context 'Here-Strings' {
        <#
            Here-strings are a fairly common programming concept, but have some
            additional quirks in PowerShell that bear mention. They start with
            the sequence @' or @" and end with the matching reverse "@ or '@
            sequence.

            The terminating sequence MUST be at the start of the line, or the
            string will not end where you want it to.
        #>
        It 'can be a literal string' {
            $LiteralString = @'
            Hullo!
'@ # This terminating sequence cannot be indented; it must be at the start of the line.

            # "Empty" space, too, is a thing of substance for some.
            $LiteralString | Should -Be '            __'
        }

        It 'can be an evaluated string' {
            # The key is in the patterns.
            $Number = __

            # These can mess with indentation rules, but have their uses nonetheless!
            $String = @"
I am number #$Number!
"@

            '__' | Should -Be $String
        }

        It 'allows use of quotation marks easily' {
            $AllYourQuotes = @"
All things that are not 'evaluated' are "recognised" as characters.
"@
            '__' | Should -Be $AllYourQuotes
        }
    }
}
