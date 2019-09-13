<# 

This is the answer file for PSKoans\IntroTraining\AboutCmdletVerbs.koans.ps1

It provides a signle function which, when given a cmdlet, will check if it exists
with the verb expected.

#>

function CheckCmdlet() {
param(
[parameter(mandatory=$true)][string]$Cmdlet,
[parameter(mandatory=$true)][string]$Verb
)
<#
.SYNOPSIS
Checks if a given cmdlet exists and starts with the verb we expect

.PARAMETER Test
Specify the name of the cmdlet you want to test

.PARAMETER Verb
Specify the verb we expect the cmdlet to start with

.INPUTS 
None. You cannot pipe objects through to DotNetTestAnswers.

.OUTPUTS
System.Boolean
Will return $true if syntax is correct and cmdlet exists, in all other instances will
return $false

.EXAMPLE
PS> CheckCmdlet -Cmdlet "Get-Command" -Verb "Get"

.LINK
https://github.com/Sudoblark/PSKoans

.LINK 
https://github.com/vexx32/PSKoans
#>
    # Check if the cmdlet exists
    if (Get-Command -Name $Cmdlet -CommandType Cmdlet) {
        # Ensure it starts with the right verb
        if ($Cmdlet.ToLower().StartsWith($Verb.ToLower())) {
            # If it exists and starts with right verb then return true
            return $true
        } else { 
             # If it doesn't exist with the right verb then return false
            return $false
        }

    } else {
        # If it doesn't exist at all then return false
        return $false
    }
}
