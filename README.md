# PowerShell Koans

|Build Status|
|      :---:      |
| [![Build Status](https://dev.azure.com/SallowCode/PSKoans/_apis/build/status/PSKoans%20CI)](https://dev.azure.com/SallowCode/PSKoans/_build/latest?definitionId=1) |

Inspired by Chris Marinos's **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell by presenting you with a set of questions.
Each [kōan](https://en.wikipedia.org/wiki/K%C5%8Dan) (each question) is represented by a failing Pester test.
Your goal is to make those tests pass by filling out the correct answer, or writing the correct code.
The koans start very simple to get you familiar with the basic concepts and progress towards more difficult.
Teaching you multiple beginner, intermediate and advanced aspects of PowerShell in the process.

To get started please navigate to [prerequisites](#prerequisites) and [getting started](#getting-started).

## Table of Contents

- [PowerShell Koans](#powershell-koans)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Install from Gallery](#install-from-gallery)
    - [Or clone the Repo](#or-clone-the-repo)
    - [Start your Journey](#start-your-journey)
      - [1. Run `Measure-Karma` to start your journey towards PowerShell enlightenment](#1-run-measure-karma-to-start-your-journey-towards-powershell-enlightenment)
      - [2. Run `Measure-Karma -Meditate` to open your Koans folder](#2-run-measure-karma--meditate-to-open-your-koans-folder)
      - [3. Run `Measure-Karma` again to see how you did](#3-run-measure-karma-again-to-see-how-you-did)
  - [Contributing](#contributing)
    - [Writing Koans](#writing-koans)

## Prerequisites

The PowerShell Koans need PowerShell version 5.1 or Core 6+ to be run.
Make sure that you have a sufficient version installed before starting the project.
You will also need the most recent version of Pester installed.
To do so, please run:

```PowerShell
# PS 5.1 (upgrade to latest Pester)
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser

# PS Core 6.0+ (Install Pester under current user)
Install-Module Pester -Scope CurrentUser
```

## Getting Started

### Install from Gallery

1. `Install-Module PSKoans -Scope CurrentUser`

### Or clone the Repo

1. `git clone` the repository into your desired directory, or download the repository as a .zip file and extract into a directory of your choice.
2. Then from a normal powershell session run `Get-ChildItem -Recurse | Unblock-File` in that directory to remove the "downloaded from internet" flag that blocks them from running.
3. Check `Get-ExecutionPolicy`: if it says 'Restricted' or 'Undefined', you need to also run `Set-ExecutionPolicy RemoteSigned` in order to allow the scripts to run.
4. Add the repository folder to `$env:PSModulePath` so that PowerShell can see it.
   - From the repository main folder, run: `$env:PSModulePath = "$(Get-Location)$([IO.Path]::PathSeparator)${env:PSModulePath}"`

### Start your Journey

#### 1. Run `Measure-Karma` to start your journey towards PowerShell enlightenment

You will be presented with a page describing your goal:

```diff
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

Describing 'Equality' has damaged your karma.

-    You have not yet reached enlightenment.

    The answers you seek...

- Expected $true, but got $null.

    Please meditate on the following code:

- [It] is a simple comparison
- at <ScriptBlock>, ...\Foundations\AboutAssertions.Koans.ps1: line 27
- 27:         __ | Should -Be $true

    Even if you speak of the wonder of it all,
    How do you deal with each thing changing?

    Your path thus far:

 [―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――] 0/246

You may run 'Measure-Karma -Meditate' to begin your meditation.
```

Inspect the red messages carefully, most importantly the last one.
The error message contains path to the file that you need to edit in order to progress forward.
In this case, you'll need to examine `Foundations\AboutAssertions.Koans.ps1`.

#### 2. Run `Measure-Karma -Meditate` to open your Koans folder

Navigate to `Foundations\AboutAssertions.Koans.ps1`. Near the top you'll see:

```powershell
It 'is a simple comparison' {
    # Some truths are absolute.
    __ | Should -Be $true
}
```

The `__` represents a blank for you to fill, and `| Should -Be $true` shows the expected result.
To pass this koan you need to replace `__` with `$true`, like this: `$true | Should -Be $true`.

#### 3. Run `Measure-Karma` again to see how you did

You passed your first koan!
You'll notice that your progress updated to `1/246` and you are presented with the next challenge.

```diff
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

Describing 'Equality' has damaged your karma.

-    You have not yet reached enlightenment.

    The answers you seek...

- Expected '__', but got 3.

    Please meditate on the following code:

- [It] expects you to fill in values
- at <ScriptBlock>, ...\Foundations\AboutAssertions.Koans.ps1: line 32
- 32:         1 + 2 | Should -Be __

    Make the mountains dance.

    Your path thus far:

+ [―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――] 1/246
```

 You are on your own from here, but the progression should be fairly smooth.
 If you need help, you can always ask around in the PowerShell communities:

- [Slack](https://j.mp/psslack)
- [Discord](https://j.mp/psdiscord)
- [Reddit](https://www.reddit.com/r/PowerShell/)
- [Twitter](https://twitter.com/hashtag/powershell)
- [PowerShell.org Forums](https://powershell.org/forums/forum/windows-powershell-qa/)

Good luck!

## Contributing

We have a great many topics to cover, including the near-infinite slew of PowerShell cmdlets that _all_ deserve koan coverage.
Naturally, we're happy to accept any and _all_ help that comes our way!

There are two main ways you can contribute:

1. Feel more than free to clone the repository, make some changes, and submit a pull request!
2. Submit any small changes you'd like make to any of the koans as an issue on the repository, and either myself or one of the helpers here will be happy to talk it over and get it sorted out.

### Writing Koans

If you are writing a koan file, the header of the file _must_ follow this format.

```powershell
using module PSKoans
[Koan(Position = $Index)]
param()
```

Comments can be placed around this area if you feel the need to as well.

`$Index` should be an unsigned integer.
The index indicates the order in which the koans should be sorted.
Try to pick an index that is unused and makes sense in the progression of lessons.
If you think it should be placed between two existing koan files, make sure to modify other indexes as necessary so that we can properly review the pull request.

The goal of the koans is to help those who have very limited knowledge learn PowerShell.
In order to do that, simplicity and accessibility are key.
There are some advanced topics out there that deserve coverage, and in order to cover them effectively we need to deal with them as clearly and simply as possible.
If you need a hand, don't be afraid to simply submit the pull request before it's ready.
You're more than welcome to submit WIP pull requests for early feedback and to ask for help if you're not sure how to proceed.
We're more than happy to offer our own suggestions and help for your ideas!

If you just want to make a general comment, some recommendations, or if you want to suggest a koan topic to cover, feel free to submit your thoughts as an issue.
I try to keep up to speed with those as best I can. :smile:
