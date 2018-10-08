#Requires -Modules PSKoans
[Koan(Position = 103)]
param()
<#
    Functions & Script Blocks (I)

    Now that we've seen the basics of variable assignment and typing,
    we'll look at some basic examples of functions and how they operate.

    A script block in PowerShell is essentially an unnamed or anonymous
    function, and can be assigned to a variable or even later assigned
    a name as needed.
#>
Describe 'Functions' {

    It 'allows you to assign a name to a sequence of commands' {
        <#
            An apt name eases the transition to abstraction.
            PowerShell function names are named in convention following
            the cmdlets; Verb-Noun. To see the list of approved
            PowerShell verbs, run 'Get-Verb' in the console.

            There are many methods of sending output from a function.
        #>
        function Get-Number {
            <#
                Explicit use of Write-Output allows multiple items to be output
                within the function without causing the function to exit.
            #>
            Write-Output 20
        }
        function Get-ReturnedNumber {
            <#
                Use of the return statement causes all output previously declared
                to be sent, along with any output passed to the return statement
                itself, then ends the function.
            #>
            return __
        }
        function Get-DroppedNumber {
            <#
                Leaving a value, or a statement that returns a value on a line
                by itself causes that output to be 'dropped' to the output
                stream, similar to functional languages. It can be considered
                an implicit (and faster) 'Write-Output'
            #>
            12
        }

        Get-Number | Should -Be __
        Get-ReturnedNumber | Should -Be 13
        Get-DroppedNumber | Should -Be __
    }

    It 'can accept parameters' {
        # Simplicity is a two-sided coin.
        function Add-Things {
            return ($args[0] + $args[1])
        }

        # Values are supplied separated by spaces, without parentheses.
        Add-Things '7' __ | Should -Be '72' # Strings add differently than numbers!
        Add-Things 1 2 | Should -Be __

        # The road to mastery is travelled with many small steps.
        function Add-Numbers ($Number1, $Number2) {
            return ($Number1 + $Number2)
        }

        Add-Numbers 1 7 | Should -Be __
        Add-Numbers __ 15 | Should -Be 31

        # Values can be passed to specified parameters
        Add-Numbers -Number2 8 -Number1 12 | Should -Be 20
    }

    It 'can declare parameters explicitly' {
        function Measure-String {
            <#
                Declaring parameters in this way allows for more advanced techniques,
                which will be covered in AboutAdvancedFunctions
            #>
            param(
                $InputString
            )
            return $InputString.Length
        }
        # How long is a piece of string?
        Measure-String 'Hello!' | Should -Be 6
        Measure-String 'Muffins' | Should -Be __
    }
}

Describe 'Script Block' {
    <#
        Script blocks can be used to group commands without defining a function.
        These can be used for various things, most commonly for parameters or
        defining a sequence of actions to be executed multiple times.

        Many PowerShell cmdlets can take script blocks as parameters, particularly
        pipeline cmdlets.

        .FORWARDHELPTARGETNAME
        about_Script_Blocks
    #>
    It 'is an anonymous function' {
        $Script = {
            throw 'This is a script block that just throws an error.'
        }

        # Sometimes, you just want to watch things burn, and the console to stream red errors.
        $Script2 = {
            # Currently, this will just output the script block as an object
            $Script # Try appending .Invoke() to this line to cause the original block to be executed
        }
        $Script | Should -Throw
        $Script2 | Should -Throw
    }
}