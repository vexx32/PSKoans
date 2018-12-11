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

    class FILL_ME_IN {}
    class __ : FILL_ME_IN {}

    class KoanAttribute : Attribute {
        [uint32] $Position

        KoanAttribute([uint32] $Position) {
            $this.Position = $Position
        }

        KoanAttribute() {
            $this.Position = [uint32]::MaxValue
        }
    }

#endregion SupportingClasses

$script:ModuleFolder = $PSScriptRoot

Write-Verbose 'Importing meditation koans'
$script:Meditations = Import-CliXml -Path "$script:ModuleFolder/Data/Meditations.clixml"

Get-ChildItem "$PSScriptRoot/Public", "$PSScriptRoot/Private" | ForEach-Object {
    Write-Verbose "Importing functions from file: [$($_.Name)]"
    . $_.FullName
}

$env:PSKoans_Folder = $Home | Join-Path -ChildPath 'PSKoans'
Write-Verbose "Koans folder set to $env:PSKoans_Folder"

if (-not (Test-Path -Path $env:PSKoans_Folder)) {
    Write-Verbose 'Koans folder does not exist; populating the folder'
    Initialize-KoanDirectory -Confirm:$false
}


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