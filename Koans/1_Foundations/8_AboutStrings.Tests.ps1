<#
    Strings

    Strings in PowerShell come in two flavours: standard strings, and string literals.
    Standard strings in PoSH are created using double-quotes, whereas string literals
    are created with single quotes.

    Unlike most other languages, standard strings in PowerShell are not literal and
    can evaluate expressions or variables mid-string in order to dynamically insert
    values into a preset string.
#>
Describe 'Strings' {
    It 'Is a simple string' {
        'string' | Should -Be __
    }
    Describe 'Literal Strings' {
        It 'assumes everything is literal' {
            $var = 'Some things you must take literally'
            $var | Should -Be __
        }
        It 'Can contain special characters' {
            $complexVar = 'They have $ or : or ; or _'
            $complexVar | Should be __
        }

    }
    It "Can expand variables" {
        $var = "apple"
        "My favorite fruit is $var" | Should -Be __
    }

    Describe "Strings can contain methods"{
        $file = Get-ChildItem C:\Windows | Select-Object -ExpandProperty FullName

        It "Can do a simple expansion" {
        "The windows directory is located here: $file" | Should -Be __
        }

        It "Handles other ways of doing the same thing" {

            "The windows directory is located $(Get-ChildItem C:\Windows | Select-Object -ExpandProperty FullName)" |
            Should -Be __
        }

        Describe "Strings can be concatenated" {
           It "Adds strings together" {
            $string1 = "This string"
            $string2 = "is cool."
            $sentence = $string1 + $string2 | Should -Be "This string is cool."

            It "Can be done simpler" {
                $string1 = "This string"
                $string2 = "is cool."
                __ | Should -Be "This string is cool"
            }
           
        }
        }


    }
}