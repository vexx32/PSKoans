<#
    Conditionals and Branching

    Conditionals operate with language keywords like if, else, and switch, and utilise 
    boolean statements to determine program control flow.

    Due to how PowerShell handles output, its conditional statements can return output 
    data, as is usually seen in functional programming languages.
#>
Describe 'Conditionals' {
    Describe 'If/Else' {
        It 'is used to alter which code should be executed based on input' {
            function Assert-IsEven ($Number) {
                if ($Number % 2 -eq 0) {
                    # Values or objects dropped to output on conditionals will still
                    # be used as output for the function.
                    'EVEN'
                }
                else {
                    'ODD'
                }
            }
        
            Assert-IsEven -Number 2 | Should -Be '__'
            Assert-IsEven -Number __ | Should -Be 'ODD'
        }
        It 'can be used alone' {
            function Set-Number ($Number) {
                if ($Number -gt 5) {
                    $Number * 10
                }
                # What happens if the conditional completely skips the if statement?
            }
            Set-Number -Number 4 | Should -Be __
            Set-Number -Number __ | Should -Be 70
        }
        It 'can be used to select a value for a variable' {
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
        It 'can also apply a condition to an else' {
            
        }
    }
    Describe 'Switch' {
        # Switches often replace stacks of if/elseif/../else conditionals
        # If you have more than an if/else, you might find a switch useful.
        It 'is used to create multiple possible branches' {
            $Folders = 4..9 | ForEach-Object {"$_" * $_}

            switch ($Folders.Count) {
                1 {
                    # Switch statements assign the current value being tested to $_
                    $Amount = 'one' + $_
                    break
                }
                5 {
                    $Amount = 'five'
                    # Usually we break out of the switch after one case matches
                    break
                }
                default {
                    # The default branch is taken when no other cases match
                    $Amount = "other $_"
                    break
                }
            }

            $Amount | Should -Be '__'
        }
        It 'can also be used to conditionally assign values' {
            $Case = 25 + (4/3) * 17 - (2/3)
            $Variable = switch ($Case) {
                45 {
                    "hello!"
                    break
                }
                47 {
                    4.5
                    break
                }
                default {
                    -1
                    break
                }
            }

            $Variable | Should -Be -1
            $Variable | Should -BeOfType [__]
        }
        It 'can go through multiple branches' {
            # Omitting the break statement allows one condition to match several cases
        }
        It 'can stop after the first matching condition' {

        }
        It 'will process each element of arrays' {

        }
        It 'accepts wildcard conditions' {

        }
        It 'accepts regex conditions' {

        }
        It 'allows use of conditional expressions' {

        }
    }
}