Write-Verbose 'Configuring PSKoans module'
Write-Verbose 'Importing data strings'

$ShowMeditationPromptData = Import-PowerShellDataFile -Path "$script:ModuleRoot/Data/Show-MeditationPrompt.Data.psd1"
$script:MeditationStrings = $ShowMeditationPromptData['Koans']
$script:MeditationPrompts = $ShowMeditationPromptData['Prompts']
Remove-Variable -Name 'ShowMeditationPromptData'

$Configuration = Get-PSKoanSetting
$LibraryFolder = if ($Configuration.LibraryFolder) {
    $Configuration.LibraryFolder
}
else {
    Set-PSKoanLocation -Path "~/PSKoans" -PassThru
}

Write-Information "Koans folder set to $LibraryFolder"

if (-not (Test-Path -Path $LibraryFolder)) {
    Write-Information "Koans folder '$LibraryFolder' was not found; creating koans directory."
    Update-PSKoan -Confirm:$false
}
