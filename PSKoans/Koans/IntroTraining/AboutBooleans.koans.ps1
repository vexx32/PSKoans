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

    There are two possible values for a boolean: $true or $false

#>

Describe "Booleans" {
    <#

        Using only booleans, so $True or $False, answer the following questions

    #>
    It "True or False" {

        # Replace the blanks with $true or $false
        $____ | Should -Be (1 -gt 2) -Because '1 is not greater than 2'

        $____ | Should -Be (1 -lt 2) -Because "1 is greater than two"

        $____ | Should -Be (10 -lt 20) -Because "10 is less than 20"

        $____ | Should -Be (10 -gt 20) -Because "10 is less than 20"
        
        $____ | Should -Be (3 -eq 3) -Because "3 is equal to 3"

        $____ | Should -Be (100 -lt 1) -Because "100 is less than one"

    }
}
