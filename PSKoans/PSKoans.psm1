Get-ChildItem "$PSScriptRoot/Public", "$PSScriptRoot/Private" | ForEach-Object {
    . $_.FullName
}
. "$PSScriptRoot/ExportedTypes.ps1"

$env:PSKoans_Folder = $Home | Join-Path -ChildPath 'PSKoans'
$script:ModuleFolder = $PSScriptRoot

if (-not (Test-Path -Path $env:PSKoans_Folder)) {
	Initialize-KoanDirectory -Confirm:$false
}