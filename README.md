# PowerShell Koans

|Current Release|Most Recent Build|
|     :---:     |      :---:      |
| [![Build status](https://ci.appveyor.com/api/projects/status/komkhtba6v3n7iji/branch/master?svg=true)](https://ci.appveyor.com/project/vexx32/pskoans/branch/master) | [![Build status](https://ci.appveyor.com/api/projects/status/komkhtba6v3n7iji?svg=true)](https://ci.appveyor.com/project/vexx32/pskoans) |

Inspired by Chris Marinos's **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell through Pester unit testing.

When you first run the koans, you'll be presented with a runtime error and a stack trace indicating where the error occured. Your goal is to make the error go away. As you fix each error, you should learn something about the PowerShell language and programming / scripting in general.

Your journey towards PowerShell enlightenment starts in the `Foundations/AboutAssertions.Koans.ps1` file. These koans will be very straightforward, so try not to overthink them! As you progress through the koans, more types of PowerShell syntax will be introduced which will allow you to solve more complicated problems and use more advanced techniques.

## Table of Contents

* [Prerequisites](#prerequisites)
* [Getting Started](#getting-started)
  * [Install From Gallery](#install-from-gallery)
  * [Clone the Repo](#clone-the-repo)
* [Contributing](#contributing)
  * [Writing Koans](#writing-koans)

## Prerequisites

The PowerShell Koans need PowerShell version 5.1 or Core 6+ to be run; make sure that you have a sufficient version installed before starting the project. You will also need the most recent version of
Pester installed. To do so, please run:

```PowerShell
# PS 5.1 (upgrade to latest Pester)
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser

# PS Core 6.0+ (Install Pester under current user)
Install-Module Pester -Scope CurrentUser
```

## Getting Started

### Install from Gallery

1. `Install-Module PSKoans -Scope CurrentUser`
2. Run `Measure-Karma` to get things started.
3. Run `Measure-Karma -Meditate` to open your Koans folder either directly or in VS Code (if installed).

### Clone the Repo

1. `git clone` the repository into your desired directory, or download the repository as a .zip file and extract into a directory of your choice.
2. Then from a normal powershell session run `Get-ChildItem -Recurse | Unblock-File` in that directory to remove the "downloaded from internet" flag that blocks them from running.
3. Check `Get-ExecutionPolicy`: if it says 'Restricted' or 'Undefined', you need to also run `Set-ExecutionPolicy RemoteSigned` in order to allow the scripts to run.
4. Run `Install-Module -Path .\Path\To\PSKoans-master`
5. Before working with the module, run `Measure-Karma` (`rake` for short) once to initialise everything, and then run `Measure-Karma -Koans` (or `-Meditate`) to open the Koans folder for you to begin your journey.

## Contributing

We have a great many topics to cover, including the near-infinite slew of PowerShell cmdlets that _all_ deserve koan coverage.

Naturally, we're happy to accept any and _all_ help that comes our way!

There are two main ways you can contribute:

1. Feel more than free to clone the repository, make some changes, and submit a pull request!
2. Submit any small changes you'd like make to any of the koans as an issue on the repository, and either myself or one of the helpers here will be happy to talk it over and get it sorted out.

### Writing Koans

If you are writing a koan file, the header of the file _must_ follow this format (comments can be placed around this area if you feel the need to as well.)

```powershell
#Requires -Modules PSKoans
[Koan(Position = $Index)]
param()
```

`$Index` should be an unsigned integer. The index indicates the order in which the koans should be sorted. Try to pick an index that is unused and makes sense. If you think it should go in between two other koan files, make sure to modify other indexes as necessary so that we can properly review the pull request.

The goal of the koans is to help those who have very limited knowledge learn PowerShell. In order to do that, simplicity and accessibility are key. There are some advanced topics out there that deserve coverage, and in order to cover them effectively we need to deal with them as clearly and simply as possible. If you need a hand, don't be afraid to simply submit the pull request before it's ready; we're more than happy to offer our own suggestions and help for your ideas!

If you just want to make a general comment or some recommendations, or if you want to suggest a koan topic to cover, feel free to submit your thoughts as an issue. I try to keep up to speed with those!
