. "$PSScriptRoot\Common.ps1"
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

        $Value -eq $Fifty | Should -Be $true
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
        $Number -is [int] | Should -Be $true
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

        $TypeOfNumber | Should -BeOfType [__]
        $TypeOfString | Should -BeOfType [__]
    }
}