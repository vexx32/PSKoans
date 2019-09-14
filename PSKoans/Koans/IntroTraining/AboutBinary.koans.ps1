using module PSKoans
[Koan(Position = 109)]
param()
<#
    Binary

    Binary is a base 2 number system, and only uses two numbers: 0 and 1.

    Binary is the basis of all computing and computational storage. It's simple & straightforward,
    and directly represents the underlying hardware states, which can only be on (1) or off (0).

    It's useful to know binary when working with PowerShell to understand how integers are represented,
    which is our next Koan. It's also extremely useful knowledge if you plan on delving deeper into computing;
    the knowledge is applicable to networking, programming, data science, databases, and essentially every
    other area of computing.

    What is represents is a base 2 number. 

    For example, the below binary represents a "byte" of data, which contains 8 "bits".
    Each bit will be either 1 or 0, as mentioned earlier.

    So:

     2^7 | 2^6 | 2^5 | 2^4 | 2^3 | 2^2 | 2^1 | 2^0
     128 |  64 |  32 |  16 |   8 |   4 |   2 |   1 
    -----+-----+-----+-----+-----+-----+-----+-----
       0     0     0     0     0     0     0     1 
    
    Or:

    00000001

    Is actually 1

    And 00000011

    Is three. As both 1 and 2 are on, and 1 + 2 is equal to 3.

#>

Describe "Binary conversion" {

    It "Bit conversion" {
        <#
            When converting from bit to a boolean try and guess what each would be
        #>

        # What would 0 be if converted to be boolean?
        # Replace __ with either $true or $false
        $____ -as [int] | Should -Be 0

        # What would 1 be if converted to be boolean?
        # Replace __ with either $true or $false
        $__ -as [int] | Should -Be 1
    }

    It "Binary to interger conversion" {
        <#
            Convert the following binary representations into intergers
        #>
        
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

    It "Interger to Binary conversion" {
        <#
            Convert the following integers into their binary representation
        #>
        
        # Replace __ with the binary value of 7
        # E.G. "__" becomes "0100"
        $Binary = "__"
        $Value = 7
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))
        
        # Replace __ with the binary value of 12
        $Binary = "__"
        $Value = 12
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 2
        $Binary = "__"
        $Value = 2
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 14
        $Binary = "__"
        $Value = 7
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

         # Replace __ with the binary value of 103
        # E.G. "__" becomes "01001110"
        $Binary = "__"
        $Value = 103
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))
        
        # Replace __ with the binary value of 250
        $Binary = "__"
        $Value = 250
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 74
        $Binary = "__"
        $Value = 74
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

        # Replace __ with the binary value of 32
        $Binary = "__"
        $Value = 32
        $Value | Should -Be ([Convert]::ToInt32($Binary, 2))

    }

}
