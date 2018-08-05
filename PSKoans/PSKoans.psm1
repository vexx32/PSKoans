Get-ChildItem "$PSScriptRoot\Public", "$PSScriptRoot\Private" | ForEach-Object {
    . $_.FullName
}

$env:PSKoans_Folder = $Home | Join-Path -ChildPath 'PSKoans'
$script:ModuleFolder = $PSScriptRoot | Split-Path -Parent

if (-not (Test-Path -Path $env:PSKoans_Folder)) {
	Initialize-KoanDirectory -Confirm:$false
}