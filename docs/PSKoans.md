---
Module Name: PSKoans
Module Guid: 45003073-0315-4aef-862f-4d9ff1bd8f4a
Download Help Link:
Help Version: 0.50.0.0
Locale: en-US
---

# PSKoans Module
## Description
Inspired by Chris Marinos's **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell by presenting you with a set of questions.
Each [kōan](https://en.wikipedia.org/wiki/K%C5%8Dan) (each question) is represented by a failing Pester test.
Your goal is to make those tests pass by filling out the correct answer, or writing the correct code.
The koans start very simple to get you familiar with the basic concepts and progress towards more difficult.
Teaching you multiple beginner, intermediate and advanced aspects of PowerShell in the process.

## PSKoans Cmdlets
### [Get-Blank](Get-Blank.md)
An auxiliary command used primarily in the koan files itself.
It is most commonly used in its alias form `__`, representing a blank space.
This command returns a blank item that never equals anything.

### [Get-Karma](Show-Karma.md)
Use this command to assess your own progress and check how you're progressing.
This command will output a simple report on your current progress.

### [Get-PSKoanFile](Get-PSKoanFile.md)
Use this command to list all koan files available.
The report will contain location information for each file in both the module and user paths.

### [Get-PSKoanLocation](Get-PSKoanLocation.md)
Retrieves the currently set PSKoans working folder path.
By default, this is set to `$HOME\PSKoans`.

### [Show-Karma](Show-Karma.md)
Use this command to assess your own progress and check how you're progressing.
This command will display a detailed report with flavour-text to guide your progress.

### [Register-Advice](Register-Advice.md)
Registers the Show-Advice command in your profile in order to display advice on startup.

### [Reset-PSKoan](Reset-PSKoan.md)
Resets a given koan file, topic, context section, or individual koan to the default state.
Use this to restore files damaged beyond repair or to reset a koan to its base state so you can try again.
The default is to reset everything (with confirmation prompts); use parameters to narrow the scope.

### [Set-PSKoanLocation](Set-PSKoanLocation.md)
Sets the PSKoans working folder path for the current session.

### [Show-Advice](Show-Advice.md)
Displays a random piece of advice from the PSKoans advice library on the screen.

### [Update-PSKoan](Show-Advice.md)
Updates selected topics, context blocks, and/or individual koan `It` blocks.
This command is provided to smooth transition to new versions of PSKoans, and to update older files.
By default, all files will be updated; specify parameters to narrow the scope.
