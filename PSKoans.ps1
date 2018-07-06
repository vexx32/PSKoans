Get-ChildItem "$PSScriptRoot\Koans" -Filter '*.ps1' | ForEach-Object {
    . $_.FullName
}