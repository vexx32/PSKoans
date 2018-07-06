Get-ChildItem -Path "$PSScriptRoot\Shared" -Filter '*.ps1' {
    . $_.FullName
}