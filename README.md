# PowerShell Koans

Inspired by Chris Marinos's **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell through Pester unit testing.

When you first run the koans, you'll be presented with a runtime error and a stack trace indicating where the error occured. Your goal is to make the error go away. As you fix each error, you should learn something about the PowerShell language and programming / scripting in general.

Your journey towards PowerShell enlightenment starts in the *(TODO: Figure out where we'll start; the basics? Pester?)* file. These koans will be very simple, so try not to overthink them! As you progress through the koans, more types of PowerShell syntax will be introduced which will allow you to solve more complicated problems and use more advanced techniques.

## Prerequisites

The PowerShell Koans need PowerShell version 5.1 or Core 6+ to be run; make sure that you have a sufficient version installed before starting the project. You will also need the most recent version of
Pester installed. To do so, please run:

```PowerShell
# PS 5.1 (upgrade to latest Pester)
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser

# PS Core 6.0+ (Install Pester under current user)
Install-Module Pester -Scope CurrentUser -SkipPublisherCheck
```

## Getting Started with the PowerShell Koans

1. Download and extract the repository as a .zip file into a directory of your choice.
2. Then from a normal powershell session run `Get-ChildItem -Recurse | Unblock-File` in that directory to remove the "downloaded from internet" flag that blocks them from running.
3. Check `Get-ExecutionPolicy`: if it says 'Restricted' or 'Undefined', you need to also run `Set-ExecutionPolicy RemoteSigned` in order to allow the scripts to run.

### With Visual Studio Code

1. Ensure you have the VSCode PowerShell extension installed.
2. Load Visual Studio Code, and select `File -> Open Folder`
3. Choose the `PSKoans-master` folder, you'll get a folder tree on the left.
4. Double click on the `PSKoans.psm1` file, and VS Code will launch a powershell console
5. In that console, enter `Import-Module c:\path\to\pskoans-master\PSKoans-Master`
6. Run `Invoke-PSKoans` (or `rake`)  and it should run and fail a test.
7. Read the error, open the file it points you to and start fixing the errors!
8. Periodically run `rake` or `Invoke-PSKoans` to re-test your progress.

### From the PowerShell Console

1. Run `Import-Module 'C:\Path\To\Downloaded\PSKoans\Folder\PSKoans-master'`
2. Run `rake` or `Invoke-PSKoans` and it will run and fail a test.
3. Run `rake -Meditate` as prompted to open the Koans folder.
4. Edit the file in your favourite editor as instructed, in order to resolve the error.
5. Re-run `rake` or `Invoke-PSKoans` in order to reevaluate the tests and check your progress.