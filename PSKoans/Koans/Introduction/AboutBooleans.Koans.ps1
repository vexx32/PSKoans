using module PSKoans
[Koan(Position = 102)]
param()
<#
    Booleans

    Booleans in PowerShell are either $true or $false, 1 or 0, on or off. They
    allow us to represent a logical, binary, state. Effectively, they represent
    the state of a single bit of data. For example:

        "Can I stop this service?"

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
    <#
        Fill in the blanks below with either $true or $false, indicating the
        result you expect from the noted expressions.

        We'll cover comparison operators in more detail later on, but here's a
        summary of the operators used here:

            -gt => "is greater than"
            -eq => "is equal to"
            -lt => "is less than"

        As an example, the expression 7 -gt 5 asserts "7 is greater than 5".
        This is a true statement, so the final value of the expression is $true.
    #>

    It 'evaluates ( 1 -gt 2 ) as a boolean expression' {
        $____ | Should -Be ( 1 -gt 2 ) -Because '1 is not greater than 2'
    }

    It 'evaluates ( 1 -lt 2 ) as a boolean expression' {
        $____ | Should -Be ( 1 -lt 2 ) -Because '1 is less than 2'
    }

    It 'evaluates ( 10 -lt 20 ) as a boolean expression' {
        $____ | Should -Be ( 10 -lt 20 ) -Because '10 is less than 20'
    }

    It 'evaluates ( 10 -gt 20 ) as a boolean expression' {
        $____ | Should -Be ( 10 -gt 20 ) -Because 'The lesser is not greater'
    }

    It 'evaluates ( 3 -eq 3 ) as a boolean expression' {
        $____ | Should -Be ( 3 -eq 3 ) -Because 'A mirror reflects true'
    }

    It 'evaluates ( 100 -lt 1 ) as a boolean expression' {
        $____ | Should -Be ( 100 -lt 1 ) -Because '100 is not less than 1'
    }
}
