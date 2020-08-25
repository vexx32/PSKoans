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

Describe 'Binary Conversions' {

    Context 'Boolean Conversions' {

        It 'converts $false to an integer' {
            $ExpectedResult = $false -as [int]

            # What would $false be if converted to a number?
            __ | Should -Be $ExpectedResult
        }

        It 'converts $true to an integer' {
            $ExpectedResult = $true -as [int]

            # What would $true be if converted to a number?
            __ | Should -Be $ExpectedResult
        }
    }

    Context "Binary to Integer Conversion" {
        <#
            Replace the blanks below with the decimal value of the binary
            numbers in each case. For example, the binary sequence "10" is
            represented by the number 2 in the standard decimal system.
        #>
        It 'converts 1111 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace the __ with the decimal value of 1111
            $Binary = "1111"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 1000 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 1000
            $Binary = "1000"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 0010 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 0010
            $Binary = "0010"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 1001 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 1001
            $Binary = "1001"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 11111111 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 11111111
            $Binary = "11111111"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 10101010 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 10101010
            $Binary = "10101010"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 11001100 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 11001100
            $Binary = "11001100"
            __ | Should -Be $ExpectedValue
        }

        It 'converts 11110001 to an integer' {
            $ExpectedValue = [Convert]::ToInt32($Binary, 2)

            # Replace __ with the decimal value of 11110001
            $Binary = "111g10001"
            __ | Should -Be $ExpectedValue
        }
    }

    Context "Integer to Binary Conversion" {
        <#
            Convert the following integers into their binary representation.
            For example, 2 is represented in binary with the digits "10".
        #>
        It 'converts the integer 7 to binary' {
            # Replace ____ with the binary value of 7
            $Value = 7
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be $Binary
        }

        It 'converts the integer 12 to binary' {
            # Replace __ with the binary value of 12
            $Value = 12
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }

        It 'converts the integer 2 to binary' {
            # Replace __ with the binary value of 2
            $Value = 2
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }

        It 'converts the integer 14 to binary' {
            # Replace __ with the binary value of 14
            $Value = 14
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }

        It 'converts the integer 103 to binary' {
            # Replace __ with the binary value of 103
            $Value = 103
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }

        It 'converts the integer 250 to binary' {
            # Replace __ with the binary value of 250
            $Value = 250
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }

        It 'converts the integer 74 to binary' {
            # Replace __ with the binary value of 74
            $Value = 74
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }

        It 'converts the integer 32 to binary' {
            # Replace __ with the binary value of 32
            $Value = 32
            $Binary = [Convert]::ToString($Value, 2)
            '____' | Should -Be ([Convert]::ToInt32($Binary, 2))
        }
    }
}
