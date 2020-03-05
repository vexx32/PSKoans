using module PSKoans
[Koan(Position = 102)]
param()
<#
    Booleans

    Booleans in PowerShell are either $true or $false, 1 or 0, on or off. They
    allow us to represent a logical, binary, state. Effectively, they represent
    the state of a single bit of data. For example:

        | "Can I stop this service?"

    The answer is yes or no, True or False.

    One example of a boolean property would be the Responding property on a
    System.Diagnostics.Process object (which is the output from Get-Process).
    This property can only show whether the process is responding (True) or not
    (False).

    Check for yourself by running the following code:

        Get-Process | Get-Member

    Then scroll down till you see the "Responding" property:

    Responding                 Property       bool Responding {get;}
#>

Describe "Booleans" {

    # Using only booleans, either $true or $false, fill in the blanks below.

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
