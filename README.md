# PowerShell Koans

![Build status](https://ci.appveyor.com/api/projects/status/2r78iucsyc89b918/branch/master?svg=true)

Inspired by Chris Marinos's **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell through Pester unit testing.

When you first run the koans, you'll be presented with a runtime error and a stack trace indicating where the error occured. Your goal is to make the error go away. As you fix each error, you should learn something about the PowerShell language and programming / scripting in general.

Your journey towards PowerShell enlightenment starts in the `1_AboutAssertions.Tests.ps1` file. These koans will be very straightforward, so try not to overthink them! As you progress through the koans, more types of PowerShell syntax will be introduced which will allow you to solve more complicated problems and use more advanced techniques.

## Prerequisites

The PowerShell Koans need PowerShell version 5.1 or Core 6+ to be run; make sure that you have a sufficient version installed before starting the project. You will also need the most recent version of
Pester installed. To do so, please run:

```PowerShell
# PS 5.1 (upgrade to latest Pester)
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser

# PS Core 6.0+ (Install Pester under current user)
Install-Module Pester -Scope CurrentUser
```

## Getting Started with the PowerShell Koans

1. a) `git clone` the repository into your desired directory, or
   b) Download and extract the repository as a .zip file into a directory of your choice.
2. Then from a normal powershell session run `Get-ChildItem -Recurse | Unblock-File` in that directory to remove the "downloaded from internet" flag that blocks them from running.
3. Check `Get-ExecutionPolicy`: if it says 'Restricted' or 'Undefined', you need to also run `Set-ExecutionPolicy RemoteSigned` in order to allow the scripts to run.

### With Visual Studio Code

1. Ensure you have the VSCode PowerShell extension installed.
2. Load Visual Studio Code, and select `File -> Open Folder`
3. Choose the `PSKoans-master` folder, you'll get a folder tree on the left.
4. Double click on the `PSKoans.psm1` file, and VS Code will launch a powershell console
5. In that console, enter `Import-Module c:\path\to\pskoans-master\PSKoans-Master`
6. Run `Get-Enlightenment` (or `rake`)  and it should run and fail a test.
7. Read the error, open the file it points you to and start fixing the errors!
8. Periodically run `rake` or `Get-Enlightenment` to re-test your progress.

### From the PowerShell Console

1. Run `Import-Module 'C:\Path\To\Downloaded\PSKoans\Folder\PSKoans-master'`
2. Run `rake` or `Get-Enlightenment` and it will run and fail a test.
3. Run `rake -Meditate` as prompted to open the Koans folder.
4. Edit the file in your favourite editor as instructed, in order to resolve the error.
5. Re-run `rake` or `Get-Enlightenment` in order to reevaluate the tests and check your progress.

### Can I Help Out / Contribute

Of course you can! We have a great many topics to cover, including the near-infinite slew of PowerShell cmdlets that _all_ deserve koan coverage.

There are two main ways you can contribute:

1. Feel more than free to clone the repository, make some changes, and submit a pull request!
2. Submit any small changes you'd like make to any of the koans as an issue on the repository, and either myself or one of the helpers here will be happy to talk it over and get it sorted out.

Do note that if you are writing a koan file, the header of the file *must* be as follows:

```powershell
#Requires -Module PSKoans
[Koan($Index)]
param()
```

Where `$Index` is simple an unsigned integer indicating the order in which the koans should be sorted. Try to pick an index that is unused and makes sense. If you think it should go in between two other koan files, make sure to modify other indexes as necessary so that we can properly review the pull request.

The goal of the koans is to help those who have very limited knowledge learn PowerShell. In order to do that, simplicity and accessibility are key. There are some advanced topics out there that deserve coverage, and in order to cover them effectively we need to deal with them as clearly and simply as possible.

If you just want to make a general comment or some recommendations, or if you want to suggest a koan topic to cover, feel free to submit your thoughts as an issue.