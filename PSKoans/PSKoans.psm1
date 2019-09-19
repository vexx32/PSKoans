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

$script:ModuleRoot = $PSScriptRoot

#region SupportingClasses

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

#region Initialization
Get-ChildItem -Path "$PSScriptRoot/Init" | ForEach-Object {
    Write-Verbose "Initializing module: [$($_.Name)]"
    . $_.FullName
}
