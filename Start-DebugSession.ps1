$env:PSModulePath = $(
    @(
        $env:PSModulePath -split [System.IO.Path]::PathSeparator
        $PSScriptRoot
    ) | Select-Object -Unique
) -join [System.IO.Path]::PathSeparator

& $PSScriptRoot/PSKoans.ezformat.ps1
Import-Module $PSScriptRoot/PSKoans

### Enter code to test below
