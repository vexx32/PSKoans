$env:PSModulePath = $(
    @(
        $env:PSModulePath -split [System.IO.Path]::PathSeparator
        $PSScriptRoot
    ) | Select-Object -Unique
) -join [System.IO.Path]::PathSeparator

& $PSScriptRoot/PSKoans.ezformat.ps1

$pester = Get-Module pester -ListAvailable | Where-Object Version -eq '5.0.2'

Import-Module (Join-Path -Path $pester.ModuleBase -ChildPath 'pester.psd1')
Import-Module $PSScriptRoot/PSKoans

### Enter code to test here
