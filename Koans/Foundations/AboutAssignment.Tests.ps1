#Requires -Module PSKoans
[Koan(102)]
param()
<#
    Variables

    PowerShell variables are defined with a $Dollar sign and some text or numbers.
    Some special characters are allowed in variable names, like underscores.

    The PoSH Practice and Style guide recommends PascalCase for variable names
    when writing PowerShell code.

    Variables can store any value, object, or collection of objects in PowerShell.
#>
Describe 'Variable Assignment' {

    It "gives a name to a value or object" {
        # Names give succinct descriptions to pieces of reality.
        $Fifty = 50
        $Value = __

        Set-Variable -Name 'Greeting' -Value "Hello!"

        $Value -eq $Fifty | Should -BeTrue
        $Greeting | Should -Be __
    }

    <#
        PowerShell variables will infer the data type where possible, for
        example [int] for whole numbers, [double] for decimals and fractions,
        [string] for text.
    #>
    It "infers types on its own" {
        $Number = 10
        $TypeOfNumber = $Number.GetType()

        $TypeOfNumber | Should -Be ([int])
    }

    It "can directly compare types" {
        # For each task, a different tool.
        $Number = 5
        $Number -is [int] | Should -BeTrue
        $Number | Should -BeOfType [int]

        $Text = "Every worthwhile step is uphill."
        $TypeOfText = $Text.GetType()
        $ExpectedType = __

        $ExpectedType | Should -BeOfType $TypeOfText
    }

    It "allows types to be explicitly set" {
        # A well-defined container decides the shape of its contents.
        [int]$Number = '42'
        $TypeOfNumber = $Number.GetType()

        # An unrestricted container may hold many different items.
        # Its contents may choose their own kind, or it be chosen for them.
        $String = [string]$true
        $TypeOfString = $String.GetType()

        $TypeOfNumber | Should -Be [__]
        $TypeOfString | Should -Be [__]
    }

    It "distinguishes between types of numbers" {
        # There are many kinds of numbers in PowerShell, but the basics are
        # [int] and [double] for integers and floating-point numbers

        $Integer = 100
        $Double = 12.0

        $Integer | Should -BeOfType [int]
        $Double | Should -BeOfType [double]
    }

    It "allows you to declare constant variables" {
        {
            Set-Variable -Name 'Constant' -Value 25 -Option Constant
            # The next operation will never succeed; constant variables cannot be altered.
            # Try uncommenting the below line to see what happens.

            # $Constant = "NewValue"
        } | Should -Not -Throw
        {
            # Contrast Read-Only variables, which can be later removed
            Set-Variable -Name 'Constant' -Value 25 -Option ReadOnly
            Remove-Variable -Name 'Constant' -Force
            $Constant = 2
            $Constant++
        } | Should -Not -Throw
    }
}
