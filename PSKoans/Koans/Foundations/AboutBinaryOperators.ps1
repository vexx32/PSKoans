using module PSKoans
[Koan(Position = 115)]
param()
<#
    Binary

    PowerShell includes a number of operators which can be used to perform binary operations.
#>
Describe 'Binary Operators' {
    BeforeAll {
        <#
            PowerShell can use the [Convert] class to change a binary string into a numeric
            value.

            The [Convert]::ToByte method is used to change the value into a byte. This method
            has two arguments:

                1. The value to convert, a string.
                2. The base of the number, 2 for binary.

            The [Convert] class contains a number of other methods for converting to different
            numeric types. These can be explored using Get-Member.

                [Convert] | Get-Member -Static

            This function is used in the Koans tasks that follow.
        #>
        function ConvertFrom-Binary {
            [CmdletBinding()]
            param (
                [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
                [String]
                $BinaryString,

                [String]
                $To = 'Byte'
            )

            process {
                switch ($To) {
                    'Byte'   { [Convert]::ToByte($BinaryString, 2) }
                    'SByte'  { [Convert]::ToSByte($BinaryString, 2) }
                    'Int16'  { [Convert]::Int16($BinaryString, 2) }
                    'UInt16' { [Convert]::ToUInt16($BinaryString, 2) }
                    'Int32'  { [Convert]::ToInt32($BinaryString, 2) }
                }
            }
        }
    }

    Context 'Bits' {
        It 'A bit has two possible values' {
            <#
                A bit is a single binary digit it can be either 0 or 1. Similar to a boolean value.

                Binary is a base 2 system.
            #>

            __ | Should -BeFalse
            __ | Should -BeTrue
        }
    }

    Context 'Bytes' {
        It 'A byte is made up of 8 bits' {
            <#
                Each bit can be set to either 0 or and bit has a value based
                on it's position.

                The most significant bit, the largest value, is first. The least
                significant bit, the smallest value, is last.

                    Bit position      Value
                    ------------      -----
                               1        128
                               2         64
                               3         32
                               4         16
                               5          8
                               6          4
                               7          2
                               8          1

                This order is known as Big Endian.
            #>

            '00000001' | ConvertFrom-Binary | Should -Be 1      # Least significant
            '________' | ConvertFrom-Binary | Should -Be 2
            '00000100' | ConvertFrom-Binary | Should -Be 4
            '________' | ConvertFrom-Binary | Should -Be 8
            '________' | ConvertFrom-Binary | Should -Be 16
            '00100000' | ConvertFrom-Binary | Should -Be 32
            '01000000' | ConvertFrom-Binary | Should -Be 64
            '________' | ConvertFrom-Binary | Should -Be 128    # Most significant
        }

        It 'is made up of 2, raised to a power' {
            <#
                Each of the values used above is 2 (the base), raised to a power (the position of the bit).

                The first position is 0. 2 raised to the power of 1 is 1. This is

                2 raised to the power of 1 is 2, and so on.
            #>

            [Math]::Pow(2, 0) | Should -Be 1
            [Math]::Pow(2, 1) | Should -Be 2
            [Math]::Pow(2, $__) | Should -Be 4
            [Math]::Pow(2, 3) | Should -Be 8
            [Math]::Pow(2, 4)| Should -Be 16
            [Math]::Pow(2, $__) | Should -Be 32
            [Math]::Pow(2, $__) | Should -Be 64
            [Math]::Pow(2, $__) | Should -Be 128
        }

        It 'can be used to create a larger number' {
            <#
                The bits that make up a byte can be used to make any number between 0 and 255.

                Each of the bits set to one is added together.
            #>

            '0000____' | ConvertFrom-Binary | Should -Be (1 + 4 + 8)
        }

        It 'can describe any byte, between 0 and 255, value using 8 bits' {
            <#
                If more than one bit is set, the values are added together.
            #>

            '11000000' | ConvertFrom-Binary | Should -Be 192
            '________' | ConvertFrom-Binary | Should -Be 133
        }

        It 'ignores leading zeros' {
            <#
                Leading zeros do not effect the value.
            #>

            '100' | ConvertFrom-Binary | Should -Be 4
            '_____' | ConvertFrom-Binary | Should -Be 16
        }
    }

    Context 'Int16, Int32, and Int64' {
        <#
            Larger integer types, such as Int32, are made up of multiple bytes.
        #>

        It 'uses 2 bytes to describe a 16-bit integer' {
            '00000000 00000001' | ConvertFrom-Binary -To Int16 | Should -BeOfType [Int16]
            '00000000 00000000 00000000 00000001' | ConvertFrom-Binary -To Int32 | Should -BeOfType [Int32]
        }
    }

    Context 'About binary AND (-band)' {
        <#
            A Binary AND comparison returns the bits from two values where both are one.

            Value 1  | 0 | 1 | 0 | 1 |
            Value 2  | 1 | 1 | 0 | 0 |
            ---------+---+---+---+---+
            Result   | 0 | 1 | 0 | 0 |
        #>

        It 'is easy to read when the value is written in binary' {
            $Value1 = '00000010' | ConvertFrom-Binary # 2
            $Value2 = '00000110' | ConvertFrom-Binary # 6

            '________' | ConvertFrom-Binary | Should -Be ($Value1 -band $Value2)
        }

        It 'compares the bits of two different values, returning those common to both' {
            __ | Should -Be 4 -band 12
        }
    }

    Context 'About binary OR (-bor)' {
        <#
            A Binary OR comparison returns the bits from two values where either is one.

            Value 1  | 0 | 1 | 0 | 1 |
            Value 2  | 1 | 1 | 0 | 0 |
            ---------+---+---+---+---+
            Result   | 1 | 1 | 0 | 1 |
        #>

        It 'is easy read when the value is written in binary' {
            $Value1 = '00000011' | ConvertFrom-Binary
            $Value2 = '00001110' | ConvertFrom-Binary

            '________' | ConvertFrom-Binary | Should -Be ($Value1 -bor $Value2)
        }

        It 'compares the bits of two different values, returning the bits set in either value' {
            __ | Should -Be 3 -bor 14
        }
    }

    Context 'About binary NOT (-bnot)' {
        <#
            The Binary NOT operator inverts the bits in a value.

            Value  | 0 | 1 | 0 | 1 |
            -------+---+---+---+---+
            Result | 1 | 0 | 1 | 0 |
        #>

        It 'inverts the bits in a value' {
            $Value = '00000011' | ConvertFrom-Binary
            $Result = '________' | ConvertFrom-Binary

            -bnot $Value | Should -Be $Result
        }
    }

    Context 'About binary exclusive OR (-bxor)' {
        <#
            A Binary exclusive OR comparison returns the bits from two values where one, but not both, is one.

            Value 1  | 0 | 1 | 0 | 1 |
            Value 2  | 1 | 1 | 0 | 0 |
            ---------+---+---+---+---+
            Result   | 1 | 0 | 0 | 1 |
        #>

        It 'inverts the bits in a value' {
            $Value1 = '10000011' | ConvertFrom-Binary
            $Value2 = '00001110' | ConvertFrom-Binary
            $Result = '________' | ConvertFrom-Binary

            $Value1 -bxor $Value2 | Should -Be $Result
        }
    }

    Context 'About shift' {
        <#
            The bits that make up a value can be shifted to the left or right.

            This changes the value depending on the direction of the shift.
        #>

        It 'allows bits to shift to the left' {
            <#
                The example below shows the result of a shift one bit to the left.

                Value  | 0 | 0 | 1 | 1 |   # 3
                -------+---+---+---+---+
                Result | 0 | 1 | 1 | 0 |   # 6

                Each bit to the left doubles the value.
            #>

            __ -shl 2 | Should -Be 8
        }

        It 'allows bits to shift to the right' {
            <#
                The example below shows the result of a shift one bit to the right.

                Value  | 1 | 1 | 0 | 0 |   # 12
                -------+---+---+---+---+
                Result | 0 | 1 | 1 | 0 |   # 6

                Each bit to the right halves the value.
            #>

            __ -shr 2 | Should -Be 2
        }

        It 'loses bits when shifting outside of the range of the type when shifting left' {
            <#
                When a shift operation pushes bits outside of the range of a numeric type
                those bits are discarded.

                A byte is made 8 bits with a maximum value of 255. In binary, 128 is the
                highest order bit:

                Binary | 10000000
                -------+---------
                Byte   | 128

                When [Byte]128 is shifted one bit to the left the result is 0. A Byte cannot hold a value
                greater than 255.
            #>

            0 | Should -Be [Byte]128 -shl 1
            __ | Should -Be [Byte]224 -shl 2
        }

        It 'loses bits when shifting outside of the range of the type when shifting right' {
            <#
                Bits will fall out of scope when shifting to the right in a similar manner as shifting left.

                When a Byte has the value 1, and the value is shifted one bit to the right the result is 0.

                Shifting the lowest order bit of a numeric value to the right will always result in 0.

                Byte  | 00000001
                Int16 | 00000000 00000001
                Int32 | 00000000 00000000 00000000 00000001
            #>

            1 | Should -Be 3 -shr 1
            __ | Should -Be 7 -shr 1
        }
    }


    Context 'About the signing bit' {
        <#
            A byte is an example of an unsigned integer. The values can range from 0 to 255, the value cannot
            be a negative number.

            Signed integers reserve a single bit to denote whether the value is positive or negative.

            The signing bit takes the place of the most significant byte.

                    Bit position      Value
                    ------------      -----
                               1      Signing bit
                               2      64
                               3      32
                               4      16
                               5      8
                               6      4
                               7      2
                               8      1

            This value is known as SByte, or signed byte. The signed byte allows numbers in the range -128 to 127.

            In .NET, SByte, Int16, Int32, and Int64 are all signed integers. Byte, UInt16, UInt32, and UInt64 are all
            unsigned integers.
        #>

        It 'allows positive values to be expressed in the same way as an unsigned integer' {
            '0000____' | ConvertFrom-Binary | Should -Be (1 + 4 + 8)
        }

        It 'uses the most significant bit to describe a negative number' {
            <#
                When the signing bit alone is set, the value is the smallest value, -128.
            #>

            '1000000' | ConvertFrom-Binary -To SByte | Should -Be -128

            <#
                This mirrors the maximum positive value for the number.
            #>

            '01111111' | ConvertFrom-Binary -To SByte | Should -Be 127

            <#
                When the signing bit is set, each value adds to the minimum.
            #>

            '10000001' | ConvertFrom-Binary -To SByte | Should -Be (-128 + 1)
            '10000010' | ConvertFrom-Binary -To SByte | Should -Be (-128 + 2)
            '1_______' | ConvertFrom-Binary -To SByte | Should -Be (-128 + 4)
            '1_______' | ConvertFrom-Binary -To SByte | Should -Be (-128 + 8)
        }

        It 'Shifting positive number left can create a negative number' {
            $Value = '01000001' | ConvertFrom-Binary -To SByte

            $Value | Should -Be 65
            $Value -shl $__ | Should -Be -126
        }
    }

    Context 'Perspective' {
        It 'A binary value has many faces' {
            # A string of binary digits, 8 bits long
            $value = '________'

            $whenItIsJustAByte = $Value | ConvertFrom-Binary -To Byte
            $whenItHasASigningBit = $Value | ConvertFrom-Binary -To SByte

            $whenItIsJustAByte | Should -Be 128
            $whenItHasASigningBit | Should -Be -127
        }
    }

    Context 'Hexadecimal and nibbles' {
        It 'A nibble is made up of 4 bits, a hexadecimal byte is made up of a left nibble and a right nibble' {
            # .NET and PowerShell cannot convert directly to 4-bit number, each of the examples below will need four zeros.
            '________' | ConvertFrom-Binary | Should -Be 0xF0
            '________' | ConvertFrom-Binary | Should -Be 0x0F
        }
    }
}