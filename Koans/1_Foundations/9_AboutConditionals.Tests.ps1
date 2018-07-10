<#
    Conditionals and Branching

    Conditionals operate with language keywords like if, else, and switch, and utilise 
    boolean statements to determine program control flow.

    Due to how PowerShell handles output, its conditional statements can return output 
    data, as is usually seen in functional programming languages.
#>
Describe 'Conditionals' {
    Describe 'If/Else' {
        It "is used to alter which code should be executed based on input" {
            function Assert-IsEven ($Number) {
                if ($Number % 2 -eq 0) {
                    # Values or objects dropped to output on conditionals will still
                    # be used as output for the function.
                    "EVEN"
                }
                else {
                    "ODD"
                }
            }
        
            Assert-IsEven -Number 2 | Should -Be "__"
            Assert-IsEven -Number __ | Should -Be "ODD"
        }
        It "can be used alone" {
            function Set-Number ($Number) {
                if ($Number -gt 5) {
                    $Number * 10
                }
                # What happens if the conditional completely skips the if statement?
            }
            Set-Number -Number 4 | Should -Be __
            Set-Number -Number __ | Should -Be 70
        }
        It "can be used to select a value for a variable" {
            function Get-Thing {
                return (Get-ChildItem -Path $env:TEMP | Select-Object -Skip 3).Length
            }
            $Thing = Get-Thing
            $Result = if ($Thing.Length -gt 5) {
                # The item dropped to output is stored in the assigned variable
                $Thing
            }
            else {
                # but depending on the outcome of the conditional, either could end up stored!
                "$Thing is less than 5"
            }
            $Result | Should -Be __
        }
    }
    Describe 'Switch' {

    }
}