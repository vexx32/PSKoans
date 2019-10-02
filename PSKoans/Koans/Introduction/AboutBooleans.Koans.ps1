using module PSKoans
[Koan(Position = 102)]
param()
<#
    Booleans

    Booleans in PowerShell are either True or False, 1 or 0, on or off.
    They allow us to represent a logical, binary, state of being.

    "Can I stop this service?" The answer is yes or no.

    Therefore, the CanStop property for a System.ServiceProcess.ServiceController object
    is a Boolean, abbreviated to bool. In other words, the only possible responses we have
    to the question, "Can I stop this service?" are either "yes" or "no".

    Check for yourself by running the following code:

        Get-Service | Get-Member

    Then scroll down till you see the "CanStop" property:

    CanStop                   Property      bool CanStop {get;}

    There are only two possible values for a boolean: $true and $false
#>

Describe "Booleans" {

    # Using only booleans, so either $true or $false, fill in the blanks below.

    It '( 1 -gt 2 ) is either true or false' {
        $____ | Should -Be ( 1 -gt 2 ) -Because '1 is not greater than 2'
    }

    It '( 1 -lt 2 ) is either true or false' {
        $____ | Should -Be ( 1 -lt 2 ) -Because '1 is less than 2'
    }

    It '( 10 -lt 20 ) is either true or false' {
        $____ | Should -Be ( 10 -lt 20 ) -Because '10 is less than 20'
    }

    It '( 10 -gt 20 ) is either true or false' {
        $____ | Should -Be ( 10 -gt 20 ) -Because 'The lesser is not greater'
    }

    It '( 3 -eq 3 ) is either true or false' {
        $____ | Should -Be ( 3 -eq 3 ) -Because 'A mirror reflects true'
    }

    It '( 100 -lt 1 ) is either true or false' {
        $____ | Should -Be ( 100 -lt 1 ) -Because '100 is not less than 1'
    }
}
