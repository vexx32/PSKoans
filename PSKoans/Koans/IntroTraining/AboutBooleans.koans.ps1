using module PSKoans
[Koan(Position = 108)]
param()
<#
    Booleans

    Booleans in PowerShell are either True or False, 1 or 0, on or off.

    They allow us to represent a logical, binary, state of being. 

    "Can I stop this service?" The answer is yes or no.

    Therefore, the CanStop property for a System.ServiceProcess.ServiceController object
    is a Boolean, shorthanded to bool. As the only possible respone we expect to the question
    "Can i stop this service?" is a yes or no answer.

    Check for yourself by running the following code:

    Get-Service | Get-Member

    Then scroll down till you see the "CanStop" property:

    CanStop                   Property      bool CanStop {get;}

    Bools are either:
    
    $True

    Or:

    $False

#>

Describe "Booleans" {
<#

    Using only booleans, so $True or $False, answer the following questions

#>

    It "True or False" {

        # Is one greater than two? 
        # Replace "__" with $True or $False
        "__" -eq (1 -gt 2) | should -be $true -Because "1 is greater than two"

        # Is one less than two
        # Replace "__" with $True or $False
        "__" -eq (1 -lt 2) | should -be $true -Because "1 is greater than two"

        # Is ten less than twenty?
        # Replace "__" with $True or $False
        "__" -eq (10 -lt 20) | should -be $true -Because "10 is less than 20"

        # Is ten greater than twenty?
        # Replace "__" with $True or $False
        "__" -eq (10 -gt 20) | should -be $true -Because "10 is less than 20"

        # Is three the same as three?
        # Replace "__" with $True or $False
        "__" -eq (3 -eq 3) | should -be $true -Because "3 is equal to 3"

        # Is 100 less than 1?
        # Replace "__" with $True or $False
        "__" -eq (100 -lt 1) | should -be $true -Because "100 is less than one"

    }


}