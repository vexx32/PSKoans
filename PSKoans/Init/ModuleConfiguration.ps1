Write-Verbose 'Configuring PSKoans module'
Write-Verbose 'Importing data strings'
$ShowMeditationPromptData = Import-PowerShellDataFile -Path "$script:ModuleRoot/Data/Show-MeditationPrompt.Data.psd1"
$script:MeditationStrings = $ShowMeditationPromptData['Koans']
$script:MeditationPrompts = $ShowMeditationPromptData['Prompts']
Remove-Variable -Name 'ShowMeditationPromptData'

$script:LibraryFolder = '~/PSKoans'
Write-Verbose "Koans folder set to $script:LibraryFolder"

if (-not (Test-Path -Path $script:LibraryFolder)) {
    Write-Verbose 'Koans folder does not exist; populating the folder'
    Update-PSKoan -Confirm:$false
}
