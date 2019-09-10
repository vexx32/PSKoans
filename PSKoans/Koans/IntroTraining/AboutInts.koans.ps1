using module PSKoans
[Koan(Position = 110)]
param()
<#
    INTs

    An INT is any whole number. It's short for Integer.

    You can have difference variations, such as an Int32, or Int16, signed or unsigned.

    The numbers relate to the number of bits that can be used to represent the integer.
    As we learned in the previous Koan, we can express this as 2 to the power of x, where
    x is the number of bits we have.

    Signed or unsigned represents if the number can represent negative values. 

    - An unsigned int can only represent positive values
    -- All bits are used for positive numbers
    - A signed int can represent positive and negative values
    -- The bits are split in half, the first half represent negative values
    and the second half positive

    In PowerShell, unsigned bits start with u.
    So Int16 is a 16 bit signed interger, and uInt16 is an unsigned 16 bit interger.

    The advantage of an unsigned int is that it takes up less memory and they are
    always going to be non-negative; if we try to assigned negative value the program
    will crash. This way we know that if we're using an unsigned int it's always going 
    to be positive.

    We'll cover 16, 32 and 64 bit integers in some more depth now.

#>

Describe "INTs" {

It "Bits"{
<#
    For the below items, decide how many bits are needed to present each.
#>

    # Would 16 be represented by 32 or 64 bits? Replace __ with 32 or 64.
    # E.G. "*__*" becomes "*32*"
    (16 | Get-Member).TypeName[0].ToString() -like "*__*" | should -be $true

    # Would 16 be represented by 32 or 64 bits? Replace __ with 32 or 64.
    # E.G. "*__*" becomes "*32*"
    (63000 | Get-Member).TypeName[0].ToString() -contains "__" | should -be $true

    # Would 16 be represented by 32 or 64 bits? Replace __ with 32 or 64.
    # E.G. "*__*" becomes "*32*"
    (65537 | Get-Member).TypeName[0].ToString() -contains "__" | should -be $true

    # Would 16 be represented by 32 or 64 bits? Replace __ with 32 or 64.
    # E.G. "*__*" becomes "*32*"
    (68000 | Get-Member).TypeName[0].ToString() -contains "__" | should -be $true

    # Would 16 be represented by 32 or 64 bits? Replace __ with 32 or 64.
    # E.G. "*__*" becomes "*32*"
    (1 | Get-Member).TypeName[0].ToString() -contains "__" | should -be $true

}


}

