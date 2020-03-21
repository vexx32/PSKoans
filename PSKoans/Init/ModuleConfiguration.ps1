Write-Verbose 'Configuring PSKoans module'
Write-Verbose 'Importing data strings'

$ShowMeditationPromptData = Import-PowerShellDataFile -Path "$script:ModuleRoot/Data/Show-MeditationPrompt.Data.psd1"
$script:MeditationStrings = $ShowMeditationPromptData['Koans']
Remove-Variable -Name 'ShowMeditationPromptData'

$Settings = Get-PSKoanSetting

Write-Information "Koans folder set to $($Settings.KoanLocation)"

if (-not (Test-Path -Path $Settings.KoanLocation)) {
    Write-Information "Koans folder '$($Settings.KoanLocation)' was not found; creating koans directory."
    Update-PSKoan -Confirm:$false
}
