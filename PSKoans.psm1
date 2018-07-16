$script:ZenSayings = Import-CliXml -Path ($PSScriptRoot | Join-Path -ChildPath "Data/Meditations.clixml")
$script:KoanFolder = $Home | Join-Path -ChildPath 'PSKoans'

if (-not (Test-Path -Path $script:KoanFolder)) {
    $script:KoanFolder = Initialize-KoanDirectory -Destination $script:KoanFolder -Confirm:$false
}