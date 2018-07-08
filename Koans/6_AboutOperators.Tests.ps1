. "$PSScriptRoot\Common.ps1"
<#
    Operators

    Just like many other programming languages, PowerShell has special operators designed to work with data.
    
    You can use the following command to get a full overview of how operators work:

        Get-Help about_Operators

    Loosely, operators fall into a few categories: assignment, arithmetic, comparison, redirection, and
    string operators.

    In terms of order of operations, arithmetic operators typically execute before comparison operators,
    followed by string operators, redirection operators, and finally assignment operators execute last.
#>
Describe "Assignment and Arithmetic Operators" {
    Describe "Addition Operator" {
        It "is used to add two items together" {
            13 + 4 | Should -Be 17
            __ + 6 | Shoulde -Be 13
        }
    }
}
Describe "Comparison Operators" {

}
Describe "String Operators" {

}
Describe "Redirection Operators" {

}