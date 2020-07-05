$env:PSModulePath = $(
    @(
        $env:PSModulePath -split [System.IO.Path]::PathSeparator
        $PSScriptRoot
    ) | Select-Object -Unique
) -join [System.IO.Path]::PathSeparator

Import-Module $PSScriptRoot/PSKoans

### Enter code to test below
Invoke-Pester -Path $PSScriptRoot/Tests/Functions/Public/Show-Karma.Tests.ps1
