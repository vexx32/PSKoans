---
Module Name: PSKoans
Module Guid: 45003073-0315-4aef-862f-4d9ff1bd8f4a
Download Help Link: https://github.com/vexx32/PSKoans/tree/master/docs/PSKoans.md
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

### [Get-PSKoanLocation](Get-PSKoanLocation.md)
Retrieves the currently set PSKoans working folder path.
By default, this is set to `$HOME\PSKoans`.

### [Measure-Karma](Measure-Karma.md)
The bread and butter of PSKoans.
Use this cmdlet to assess your own progress and check how you're progressing.

### [Register-Advice](Register-Advice.md)
Registers the Show-Advice command in your profile in order to display advice on startup.

### [Set-PSKoanLocation](Set-PSKoanLocation.md)
Sets the PSKoans working folder path for the current session.

### [Show-Advice](Show-Advice.md)
Displays a random piece of advice from the PSKoans advice library on the screen.
