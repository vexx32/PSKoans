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

    class KoanAttribute : System.Attribute {
        [uint32] $Position

        KoanAttribute($Position) {
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