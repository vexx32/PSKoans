<#
.SYNOPSIS
    Provides a library of editable Pester tests to assist learning PowerShell.
.DESCRIPTION
    Provides a simplified interface with Pester tests that describe core PowerShell
    functions, language features, and techniques, in order to facilitate quickly
    learning the PowerShell language.
.EXAMPLE
    PS> Measure-Karma

    Execute the recorded tests to check your progress.
.NOTES
    Author: Joel Sallow
#>

#region SupportingClasses

class KoanAttribute : Attribute {
    [uint32] $Position = [uint32]::MaxValue
    [string] $Module = '_powershell'

    Koan() {}
}

class Koan : KoanAttribute {
    Koan() : base() {}
}

# load classes

Get-ChildItem -Path "$PSScriptRoot/Classes" | ForEach-Object {
    Write-Verbose "Importing classes from file: [$($_.Name)]"
    . $_.FullName
}

#endregion SupportingClasses

#region ImportCommands

Get-ChildItem -Path "$PSScriptRoot/Public", "$PSScriptRoot/Private" | ForEach-Object {
    Write-Verbose "Importing functions from file: [$($_.Name)]"
    . $_.FullName
}

#endregion ImportCommands

#region ModuleConfiguration

Write-Verbose 'Configuring PSKoans module'
$script:ModuleRoot = $PSScriptRoot

Write-Verbose 'Importing data strings'
$ShowMeditationPromptData = Import-PowerShellDataFile -Path "$script:ModuleRoot/Data/Show-MeditationPrompt.Data.psd1"
$script:MeditationStrings = $ShowMeditationPromptData['Koans']
$script:MeditationPrompts = $ShowMeditationPromptData['Prompts']
Remove-Variable -Name 'ShowMeditationPromptData'

$script:LibraryFolder = $Home | Join-Path -ChildPath 'PSKoans'
Write-Verbose "Koans folder set to $script:LibraryFolder"

if (-not (Test-Path -Path $script:LibraryFolder)) {
    Write-Verbose 'Koans folder does not exist; populating the folder'
    Initialize-KoanDirectory -Confirm:$false
}

#endregion ModuleConfiguration

try {
    Add-AssertionOperator -Name Fail -Test {
        param ($ActualValue, [switch] $Negate, [string] $Because)

        # look at  https://github.com/pester/Pester/blob/master/Functions/Assertions/BeTrueOrFalse.ps1
        # for inspiration, or here https://mathieubuisson.github.io/pester-custom-assertions/

        if ($Negate) {
            return [PSCustomObject]@{
                Succeeded      = $false
                FailureMessage = "Should -Not -Fail is not a valid assertion."
            }
        }

        if (-not $Because) {
            $Message = "The test failed, because the script reached the Should -Fail command call."
        }
        else {
            $Reason = ($Because.Trim().TrimEnd('.') -replace '^because\s', '')
            $Message = "The test failed, because $Reason."
        }

        [PSCustomObject]@{
            Succeeded      = $false
            FailureMessage = $Message
        }
    }
}
catch {}
