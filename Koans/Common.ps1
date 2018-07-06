Get-ChildItem -Path "$PSScriptRoot\Shared" -Filter '*.ps1' | ForEach-Object {
    . $_.FullName
}