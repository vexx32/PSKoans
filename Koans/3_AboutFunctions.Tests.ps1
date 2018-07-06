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
        # An apt name eases the transition to abstraction.
        # PowerShell function names are named in convention following
        # the cmdlets; Verb-Noun. To see the list of approved
        # PowerShell verbs, run 'Get-Verb' in the console.
        function Get-Number {
            Write-Output 20
        }

        Get-Number | Should -Be __
    }

    
}