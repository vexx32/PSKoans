using module PSKoans
[Koan(Position = 107)]
param()
<#
    Binary

    Binary is a base 2 number system, and only uses two numerals: 0 and 1.

    Binary is the basis of all computing and computational storage. All data is
    stored both on hard drives and in memory in a series of states that can be
    interpreted as a series of 1s and 0s, which directly represents the
    underlying on or off hardware states.

    It's useful to know binary when working with PowerShell to understand how
    numbers are commonly represented, which will be covered in more detail in a
    future topic.

    It's also extremely useful knowledge if you plan on delving deeper into
    computing; the knowledge is applicable to networking, programming,
    data science, databases, and essentially every other area of computing.

    For example, the below binary represents a "byte" of data, which contains
    eight "bits," each of which will be either 1 or 0, as mentioned earlier.

    The table below demonstrates some of the structure of how this works. It's
    very much comparable to the commonly-used base-10 number system, but since
    binary is base 2 instead, each column is a power of 2, not of a power of 10.

        | 2^7 | 2^6 | 2^5 | 2^4 | 2^3 | 2^2 | 2^1 | 2^0 |
        | 128 |  64 |  32 |  16 |   8 |   4 |   2 |   1 |
        +-----+-----+-----+-----+-----+-----+-----+-----+
            0     0     0     0     0     0     0     1

    Written in a simpler binary form: 00000001 (Actual value: 1)

    That's simple enough. But since there are only two numerals in a binary
    number system, you have to use extra columns to represent numbers larger
    than 1.

    As such, 00000011 has a value of 3.

    As both 1 and 2 columns are
    one, and 1 + 2 is equal to 3.
#>

Describe "Binary conversion" {

    It "Bit conversion" {
        # What would 0 be if converted to be boolean?
        # Replace __ with either $true or $false
        $____ -as [int] | Should -Be 0

        # What would 1 be if converted to be boolean?
        # Replace __ with either $true or $false
        $____ -as [int] | Should -Be 1
    }

    It "Binary to integer conversion" {
        # Replace __ with the decimal value of 1111
        # E.G. __ becomes 1234
        $Binary = "1111"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 1000
        $Binary = "1000"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 0010
        $Binary = "0010"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 1001
        $Binary = "1001"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 11111111
        $Binary = "11111111"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 10101010
        $Binary = "10101010"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 11001100
        $Binary = "11001100"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the decimal value of 11110001
        $Binary = "11110001"
        $Value = __
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))


    }

    It "Integer to Binary conversion" {
        <#
            Convert the following integers into their binary representation
        #>

        # Replace __ with the binary value of 7
        # E.G. "__" becomes "0100"
        $Binary = "____"
        $Value = 7
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 12
        $Binary = "____"
        $Value = 12
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 2
        $Binary = "____"
        $Value = 2
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 14
        $Binary = "____"
        $Value = 14
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 103
        # E.G. "__" becomes "01001110"
        $Binary = "____"
        $Value = 103
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 250
        $Binary = "____"
        $Value = 250
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 74
        $Binary = "____"
        $Value = 74
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 32
        $Binary = "____"
        $Value = 32
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))
    }
}
