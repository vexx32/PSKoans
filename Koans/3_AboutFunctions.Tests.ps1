<#
    Functions & Script Blocks (I)

    Now that we've seen the basics of variable assignment and typing,
    we'll look at some basic examples of functions and how they operate.

    A script block in PowerShell is essentially an unnamed or anonymous
    function, and can be assigned to a variable or even later assigned
    a name as needed.
#>

Describe "Functions" {
    It "allows you to assign a name to a sequence of commands" {
        <#
            An apt name eases the transition to abstraction.
            PowerShell function names are named in convention following
            the cmdlets; Verb-Noun. To see the list of approved
            PowerShell verbs, run 'Get-Verb' in the console.
            
            There are many methods of sending output from a function.
        #>

        # Explicit use of Write-Output allows multiple items to be output within the function
        # without causing the function to exit.
        function Get-Number {
            Write-Output 20
        }
        # Use of the return statement causes all output previously declared to be sent,
        # along with any output passed to the return statement itself, then ends the function.
        function Get-ReturnedNumber {
            return __
        }
        # Leaving a value or a statement that returns a value on a line by itself causes
        # that output to be "dropped" to the output stream, similar to functional languages.
        # It can be considered an implicit (and faster) 'Write-Output'
        function Get-DroppedNumber {
            12
        }

        Get-Number | Should -Be __
        Get-ReturnedNumber | Should -Be 13
        Get-DroppedNumber | Should -Be __
    }

    It "can accept parameters" {
        # Simplicity is a two-sided coin.
        function Add-Numbers ($Number1, $Number2) {
            return ($Number1 + $Number2)
        }

        # Values are supplied separated by spaces, without parentheses.
        Add-Numbers 1 7 | Should -Be __
        Add-Numbers __ 15 | Should -Be 31
        
        # Values can be passed to specified parameters
        Add-Numbers -Number2 8 -Number1 12 | Should -Be 20
    }

    It "can declare parameters explicitly" {
        function Measure-String {
            # Declaring parameters in this way allows for more advanced techniques,
            # which will be covered in Advanced Functions
            param(
                $InputString
            )
            return $InputString.Length
        }
    }
}