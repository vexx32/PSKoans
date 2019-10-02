using module PSKoans
[Koan(Position = 320)]
param()

<#
    AboutRegularExpressions

    TODO: Explanation
#>
describe 'Working with regular expressions' {
    <#
        Regular expressions, or regex, are sequences of characters that define a search pattern which is then used to find or
        replace parts of strings. This is especially handy for things like extracting text from log files, determining if some
        user input matches some criteria, or replacing parts of a string with other values.

        As you learn about regex, you'll see more and more opportunities to use it as you code.
    #>

    it 'performs boolean matching' {
        <# 
            In PowerShell, the -match operator returns a boolean result based on whether the pattern (regex) on the right side is
            found within the string on the left side. Yes, in this case 'string' is a regular expression!
        #>

        'a string value' -match 'string' | should -BeTrue

        $trueValue = '__'
        $trueValue -match 'climb' | should -BeTrue

        $falseValue = '__'
        $falseValue -match 'climb' | should -BeFalse
    }

    it 'manipulates strings' {
        <#
            The -replace operator returns a string. On the left side, it takes a string, and on the right side it takes two arguments.
            The first is a regular expression to search the string for, and the second is the string to replace the pattern with if it
            is found in the string.
        #>

        $replacementExample = 'Here is a simple string.' -replace 'simple string', 'string that got something replaced'
        $replacementExample | should -Be 'Here is a string that got something replaced.'

        $replacePattern = '__'
        $replaceWith = '__'
        $newString = 'The thing I love most about regex is that it is simple' -replace $replacePattern, $replaceWith
        $newString | should -Be 'The thing I love most about regex is that it is flexible'
    }

    it 'returns RegularExpressions.Match objects' {
        <#
            You don't have to confine yourself to the regex operators that come with PowerShell. Since you have access to all kinds of
            .NET goodness, you can start taking advantage of those now that you are learning how regular expressions work! The following
            example looks at the Matches() method that's a part of the [Regex] class.
        #>

        $regexMatch = [Regex]::Matches('Running through a forest', 'through')
        $regexMatch.GetType().FullName | should -Be '__'
        $regexMatch.Value | should -Be '__'
    }
}

describe 'Quantifiers' {
    <#
        Until now, all of the regex exmaples have been literal values. For instace, searching for the pattern "through" within the
        string "Running through a forest", the pattern "through" is literally the characters t h r o u g h in that order. Since
        quantifiers and many other symbols in regex have special meanings, it can sometimes be confusing for humans to read regular
        expressions.

        Quantifiers are the first group of symbols in regex that you are learning about now which have a non-literal meaning. Their
        presence in a regular expression does not mean that the pattern of interest is that literal character, but rather the special
        meaning that the character represents. In this case, quantifiers are used to describe "how many of" a pattern that come immediately
        before it might exist.
    #>
    
    # *
    it 'specifies 0 or more of something' {
        <#
            The * (star) character specifies "0 or more" of the symbol or group that comes immediately before it. In this case, the pattern
            can be read aloud as "zero or more of the letter p, then the letters e a r s."
        #>

        'pears' -match 'p*ears' | should -BeTrue

        [bool]$starMatch = __ # Should be either $true or $false
        'shears' -match 'p*ears' | should -Be $starMatch

        <#
            What happened in that last example? What part of 'shears' matched the pattern 'p*ears'? When you use the -match operator, you
            can see some interesting information in the automatic variable $matches. $matches is a collection of the match objects that
            are created when you use the -match operator. This isn't as flexible nor as robust as using [regex]::Matches(), but it's handy
            in a pinch.
            
            In this case, you'll see that the "sh" in "shears" weren't part of the match. The pattern "zero or more p's, followed by e a r
            s" is found in the string, even though there are parts of the string that aren't relevant to that matching effort.

            $matches[0] is always your most recent match.
        #>

        $matches[0] | should -Be '__'
    }

    # +
    it 'specifies 1 or more of something' {
        # The + (plus) symbol is a lot like the star, but instead of matching zero or more, it matches one or more.

        '__' -match 'p+ickles' | should -BeTrue

        $mightBePumpkin = '__'
        $mightBePumpkin += 'umpkin'
        $mightBePumpkin -match 'p+umpkin' | should -BeFalse
    }

    # ?
    it 'specifies 0 or 1 of something' {
        # The ? (question mark) matches "zero or one" of something.
        
        [bool]$boatMatch = __ # Should be either $true or $false
        'flying through the sky' -match 'f+lying' | should -Be $boatMatch
        
        [bool]$floatMatch = __ # Should be either $true or $false
        'floating away' -match 'b+oat' | should -Be $floatMatch
    }
}

describe 'Special Symbols' {
    <#
        In regex, there are far more symbols with unique meanings than just quantifiers. What comes next is not a definitive guide to EVERY
        SINGLE ONE, but rather an introduction to some of the most common and useful special symbols in regex.
        
        This is ^\where things st\Art getting \weir\d$
    #>
    

    # . (period)
    it 'matches any character' {
        # The . (period) matches literally any character

        [bool]$morningMatch = __ # Should be either $true or $false
        'Lazy Sunday mornings' -match 'S.nday' | should -Be $morningMatch

        '__' -match 'invi.a.ion' | should -BeTrue
    }

    # \n
    it 'matches new lines' {
        <#
            The \n symbol is the first regex symbol you've encountered that isn't just a single character. Normally if you saw a lowercase "n" in
            a regex, it would just mean "literally the letter n". When it's preceded by a backslash, however, that "n" takes on a special meaning.
            In this case, \n matches new lines.

            There are many more regex symbols that are single letters preceded by a backslash. In fact, the backslash is probably the single most
            important character in all of regex.
        #>

        $multiLine = @"
They might look
similar and look
soft, but you should
never confuse a
wild cougar for
a domestic cat
"@
        $catPattern = '__'
        $catPattern += '\n'
        $multiLine -match $catPattern | should -BeTrue
    }

    # \d \D
    it 'matches digits and non-digits' {
        <#
            The \d symbol matches digits (the numbers 0 - 9 inclusive), while the symbol \D matches anything OTHER THAN a digit. Yes, regular
            expressions are case sensitive. This "lower case for affirmative, upper case for negative" pattern is common among regex symbols
            as you'll discover as you carry on.
        #>

        '__' -match '\d' | should -BeTrue
        '__' -match '\d\d\d' | should -BeTrue
    }

    # \w \W
    it 'matches word characters' {
        # \w matches word characters which are letters, numbers, and underscores. The \W symbol matches anything else.

        '***' -match '__' | should -BeTrue
        'warmth' -match '__' | should -BeTrue
    }

    # ^ $
    it 'matches the start and end of lines' {
        <#
            The ^ symbol matches the start of a line, which is not normally represented in English with a character. The $ represents the end
            of a line.
        #>

        $startAndEnd = '__'
        $startAndEnd -match '^a' | should -BeTrue
        $startAndEnd -match 'z$' | should -BeTrue
    }

    # \s \S
    it 'matches (non-) whitespace characters' {
        # \s matches whitespace characters (space, tab, etc.) while \S matches anything other than whitespace

        'Room to grow' -match '__' | should -BeTrue
        '    ' -match '__' | should -BeFalse        # Careful to only fill in a value for the '__', not the '    '
        'accordian' -match '__' | should -BeFalse
        'accordian' -match '__' | should -BeTrue
    }

    # escape
    it 'escapes other special symbols' {
        <#
            As you know now, the backslash is basically a magic regex wand that gives some normal characters special meanings. It does more
            than that, though. The backslash can also take special meaning away from characters, even itself. The process of removing the
            special meaning from a letter in regex is called "escaping".
        #>

        # Escape the period character to match a literal period instead of "any character"
        'This . character means something else in regex' -match '\.' | should -BeTrue
        $matches[0] | should -Be '__'

        $dollarValue = 'The price is $4.99.'
        $dollarMatch = '__'
        [regex]::Matches($dollarValue, $dollarMatch).Value | should -Be '$4.99'

        $slashPath = '\\path\with\slashes'
        $slashPattern = '__'
        [regex]::Matches($slashPath, $slashPattern).Value | should -Be '\slashes'
    }
}

describe 'Brackets and Braces' {
    <#
        Brackets and braces don't have one overarching purpose in regular expressions. Different types of brackets and braces all mean different
        things. Sometimes other regex symbols meanings change when they're found inside some brackets or braces.
    #>
    
    # curly braces
    it 'works like a custom quantifier' {
        <#
            Curly braces are effectively customizable quantifiers. The star, plus, and question mark quantifiers from earlier are static in their
            meaning. Star always means "zero or more", question mark always means "one or zero", and plus always means "one or more". Those cover
            tons of use cases and examples, but there are plenty more situations where you want to be more specific.
        #>

        # The portion of this regex in curly braces acts as a quantifier for the symbol that comes immediately before it. It means "exactly 4 digits."
        'I can count to 1024' -match '\d{4}' | should -BeTrue
        $matches[0] | should -Be '__'

        '__' -match '\w{10}' | should -BeTrue
        '__' -match '\w{10}' | should -BeFalse

        # One can use curly braces to give a range of numbers. This one means "between 2 and 4 of any character"
        'Paper airplane' -match '.{2,4}'

        $fruitMatch = 'p'
        $fruitMatch += '__'
        [regex]::Matches('Apples', $fruitMatch).Value | Should -Be 'pp'
        $fruitMatch.Contains('}') | should -BeTrue     # Make sure you use curly braces!

        # If you omit the second number, the custom quantifier becomes "this many or more". This one means "two or more non-whitespace characters"
        [bool]$whitespaceMatch = __ # Should be either $true or $false
        'The moon in June is a big balloon' -match '\s{2,}' | should -Be $whitespaceMatch
    }

    # round brackets
    it 'groups patterns together' {
        <#
            Round brackets are used to create groups of symbols. These groups can then have quantifiers applied to the entire group, or be used in
            approximately 42 trillion other ways. This is just the tip of the round bracket/regular expression groups iceberg.
        #>

        [regex]::Matches('Bears Beat Bongos', '(B.+){3}').Value | should -Be '__'

        $groupingPattern = '__'
        [regex]::Matches('BadgerBadgerBadger', $groupingPattern).Value | should -Be 'BadgerBadgerBadger'
        $groupingPattern.Contains(')') | should -BeTrue    # Use a group!

    }

    # square brackets
    it 'defines a set' {
        <#
            Square brackets denote a set, or array/collection, of symbols within a regular expression. Imagine a pattern that might read "a or b
            or c or d". You may use square brackets to create that regex. The set contained within the square brackets represent one character
            within the string being searched.
        #>

        [bool]$eolMatch = __ # Should be either $true or $false
        'End of the line' -match '[efg]$' | should -Be $eolMatch

        '__' -match '[abcdefg]$' | should -BeTrue

        # Normally, the ^ character means "start of a line", but inside of square brackets, it negates the set. Instead of "these symbols" it means "not these symbols"
        '__' -match '[^abcdefg]$' | should -BeTrue

        # What do you think you might do if you want to match a literal ^ symbol within a set? Use the ^ (caret) symbol in this one.
        $caretMatch = '[__]'
        '^&*' -match $caretMatch | should -BeTrue
        $caretMatch.Contains('^') | should -BeTrue      # Use the caret symbol!
    }
}

describe 'Medatative Examples' {
    <#
        Here are some challenges for you to put your new skills to work on.
    #>
    
    it 'is handy for isolating parts of strings' {
        # Isolate a username from a domain\username string using just one regex pattern
        $usernamePattern = '__'
        [regex]::Matches('cat\harley', $usernamePattern).Value | should -Be 'harley'
        [regex]::Matches('cat\kali', $usernamePattern).Value | should -Be 'kali'
        [regex]::Matches('human\thomas', $usernamePattern).Value | should -Be 'thomas'
    }

    it 'validates user input' {
        # Validate a bunch of phone numbers
        $phoneNumbers = @(
            '1 425 555 1234',
            '1-425-555-4321',
            '1.425.555.6789',
            '01234'
            '+14255556789'
        )

        $sanitizedNumbers = $phoneNumbers -replace '__' 
        $sanitizedNumbers | should -Be @('14255551234', '14255554321', '14255556789', '01234', '14255556789')

        $validPhoneNumbers = [regex]::Matches($sanitizedNumbers, '__').Value
        $validPhoneNumbers | should -Be @('14255551234', '14255554321', '14255556789', '14255556789')
    }
}
