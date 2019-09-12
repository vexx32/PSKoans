using module PSKoans
[Koan(Position = 109)]
param()
<#
    Binary

    Binary is a base 2 number system, and only uses two numbers: 0 and 1.

    Binary is the basis of all computing and computational storage. It's elegant,
    and the 0/1 method is quick to detect and off or on state.

    It's useful to know binary when working with PowerShell to understand how integers are represented,
    which is our next Koan. It's also extremely useful knowledge if you plan on delving deeper into computing;
    the knowledge is applicable to networking, programming, data science, databases, and essentially every
    other area of computing.

    The structure is as follows

    - 0 or 1 represents a bit
    - 4 bits represents a nibble
    - 8 bits, or two nibbles, represents a byte
    - 1024 bytes represents a kilobyte (KB)
    - 1024KB represents a megabyte (MB)
    - 1024MB represents a gigabyte (GB)
    - 1024GB represents a terrabyte (TB)

    And so on and so forth

    What is represents is a base 2 number. The values in a byte are as follows:

    --------------------------------------
    # 128 # 64 # 32 # 16 # 8 # 4 # 2 # 1 #
    --------------------------------------

    With each of these bits either being on or off.

    So

    --------------------------------------
    # 128 # 64 # 32 # 16 # 8 # 4 # 2 # 1 #
    --------------------------------------
    #  0  # 0  #  0  # 0 # 0 # 0 # 0 # 1 #
    
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
    # Replace "__" with either $true or $false
    "__" -eq [Boolean]0 | should -be $true

    # What would 1 be if converted to be boolean?
    # Replace "__" with either $true or $false
    "__" -eq [Boolean]1 | should -be $true

    }

    It "Nibble conversion" {
        <#
            Convert the following  nibbles into full numbers
        #>
        
        # Replace "__" with the decimal value of 1111
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("1111",2)) -eq "__" | should -be $true
        
        # Replace "__" with the decimal value of 1000
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("1000",2)) -eq "__" | should -be $true

        # Replace "__" with the decimal value of 0010
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("0010",2)) -eq "__" | should -be $true

        # Replace "__" with the decimal value of 1001
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("1001",2)) -eq "__" | should -be $true

    }

    It "Byte Conversion" {
        <#
            Convert the following bytes into full numbers
        #>

        # Replace "__" with the decimal value of 11111111
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("11111111",2)) -eq "__" | should -be $true

        # Replace "__" with the decimal value of 10101010
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("10101010",2)) -eq "__" | should -be $true

        # Replace "__" with the decimal value of 11001100
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("11001100",2)) -eq "__" | should -be $true

        # Replace "__" with the decimal value of 11110001
        # E.G. "__" becomes 1234
        ([Convert]::ToInt32("11110001",2)) -eq "__" | should -be $true



    }
}
