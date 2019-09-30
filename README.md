# PowerShell Koans

| [![PSKoans Logo](./logo-128px.png)](./logo.svg)                                                 |
| :---------------------------------------------------------------------------------------------: |
| [![Build Status][build-badge]][build-link]<br/>[![Coverage Status][coverage-badge]][build-link] |

## About the Author

### Joel Sallow

- [Blog](https://vexx32.github.io)
- [Twitter](https://twitter.com/vexx32)
- Currently looking for work? [Yes](https://hirejoel.dev)

## Synopsis

Inspired by Chris Marinos's **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell by presenting you with a set of questions.
Each [kōan](https://en.wikipedia.org/wiki/K%C5%8Dan) (each question) is represented by a failing Pester test.
Your goal is to make those tests pass by filling out the correct answer, or writing the correct code.
The koans start very simple to get you familiar with the basic concepts and progress towards more difficult.
Teaching you multiple beginner, intermediate and advanced aspects of PowerShell in the process.

To get started please navigate to [prerequisites](#prerequisites) and [getting started](#getting-started).

## Table of Contents

- [PowerShell Koans](#powershell-koans)
  - [About the Author](#about-the-author)
    - [Joel Sallow](#joel-sallow)
  - [Synopsis](#synopsis)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Install from Gallery](#install-from-gallery)
    - [Or Download the Repo](#or-download-the-repo)
    - [Start your Journey](#start-your-journey)
      - [1. Run `Show-Karma` to start your journey towards PowerShell enlightenment](#1-run-show-karma-to-start-your-journey-towards-powershell-enlightenment)
      - [2. Run `Show-Karma -Meditate` to open your Koans folder](#2-run-show-karma--meditate-to-open-your-koans-folder)
      - [3. Run `Show-Karma` again to see how you did](#3-run-show-karma-again-to-see-how-you-did)
  - [Contributing](#contributing)

## Prerequisites

- Windows PowerShell version 5.1 / PowerShell 6+
- NuGet
- Pester

If you've never installed PowerShell modules before, you need to first install the NuGet PackageProvider to enable modules to be installed:

```PowerShell
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
```

To install the latest version of Pester, use the appropriate command for your version of PowerShell:

```PowerShell
# PS 5.1 (upgrade to latest Pester)
Install-Module Pester -Force -SkipPublisherCheck -Scope CurrentUser

# PS 6.0+ (Install Pester under current user)
Install-Module Pester -Scope CurrentUser
```

## Getting Started

### Install from Gallery

1. `Install-Module PSKoans -Scope CurrentUser`

### Or Download the Repo

1. `git clone` the repository into your desired directory, or download the module zip file from the build artifacts available on [this page](https://dev.azure.com/SallowCode/PSKoans/_build/latest?definitionId=1).
2. From a normal powershell session run `Get-ChildItem -Recurse | Unblock-File` in that directory to remove the "downloaded from internet" flag that blocks them from running.
3. Check `Get-ExecutionPolicy`: if it says 'Restricted' or 'Undefined', you need to also run `Set-ExecutionPolicy RemoteSigned` in order to allow the scripts to run.
4. Add the repository folder to `$env:PSModulePath` so that PowerShell can see it.
   - From the repository main folder, run: `$env:PSModulePath = "$(Get-Location)$([IO.Path]::PathSeparator)${env:PSModulePath}"`

### Start your Journey

#### 1. Run `Show-Karma` to start your journey towards PowerShell enlightenment

You will be presented with a page describing your goal:

```code
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

Describing 'Equality' has damaged your karma.

    You have not yet reached enlightenment.

    The answers you seek...

Expected strings to be the same, but they were different.
Expected length: 5
Actual length:   2
Strings differ at index 0.
Expected: 'True!'
But was:  '__'
-----------^

    Please meditate on the following code:

[It] expects you to fill in values
at <ScriptBlock>, C:\Users\Joel\PSKoans\Foundations\AboutAssertions.Koans.ps1: line 32
32:        '__' | Should -Be 'True!'

    ▌ Mountains are merely mountains.

    You examine the path beneath your feet...

 [AboutAssertions]: [――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――] 0/4

 [Total]: [―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――] 1/279

Type 'Show-Karma -Meditate' when you are ready to begin your meditations.
```

Inspect the red messages carefully, most importantly the last one.
The error message contains path to the file that you need to edit in order to progress forward.
In this case, you'll need to examine `Foundations\AboutAssertions.Koans.ps1`.

#### 2. Run `Show-Karma -Meditate` to open your Koans folder

Navigate to `Foundations\AboutAssertions.Koans.ps1`. Near the top you'll see:

```powershell
It 'is a simple comparison' {
    # Some truths are absolute.
    '__' | Should -Be 'True!'
}
```

The `__` represents a blank for you to fill, and `| Should -Be 'True!'` shows the expected result.
To pass this koan you need to replace `__` with `True!`, like this: `'True!' | Should -Be 'True!'`.

#### 3. Run `Show-Karma` again to see how you did

You passed your first koan!
You'll notice that your overall progress updated to `1/279` and you are presented with the next challenge.

```code
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

Describing 'Equality' has damaged your karma.

    You have not yet reached enlightenment.

    The answers you seek...

Expected 3, but got .

    Please meditate on the following code:

[It] expects you to fill in values
at <ScriptBlock>, C:\Users\Joel\PSKoans\Foundations\AboutAssertions.Koans.ps1: line 32
32:        __ | Should -Be (1 + 2)

    ▌ The most important thing is to find out what is the most important thing.

    You examine the path beneath your feet...

 [AboutAssertions]: [▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰―――――――――――――――――――――――――――――――――――――――――――――] 1/4

 [Total]: [―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――] 1/279

Type 'Show-Karma -Meditate' when you are ready to begin your meditations.
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

If you would like to contribute to PSKoans, please check out the [Contributing](https://github.com/vexx32/PSKoans/blob/master/CONTRIBUTING.md) document.

[build-badge]: https://dev.azure.com/SallowCode/PSKoans/_apis/build/status/PSKoans%20CI
[build-link]: https://dev.azure.com/SallowCode/PSKoans/_build/latest?definitionId=1
[coverage-badge]: https://img.shields.io/azure-devops/coverage/SallowCode/PSKoans/1
