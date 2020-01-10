# PowerShell Koans

|                                                | Build Status                                                                                    |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| [![PSKoans Logo](./logo-64px.png)](./logo.svg) | [![Build Status][build-badge]][build-link]<br/>[![Coverage Status][coverage-badge]][build-link] |

- [PowerShell Koans](#powershell-koans)
  - [About the Author](#about-the-author)
    - [Joel Sallow](#joel-sallow)
  - [Synopsis](#synopsis)
  - [Command Reference](#command-reference)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Install from Gallery](#install-from-gallery)
    - [Or Download the Repo](#or-download-the-repo)
  - [Start your Journey](#start-your-journey)
    - [1. Run `Show-Karma` to start your journey towards PowerShell enlightenment](#1-run-show-karma-to-start-your-journey-towards-powershell-enlightenment)
    - [2. Run `Show-Karma -Meditate` to open your Koans folder](#2-run-show-karma--meditate-to-open-your-koans-folder)
    - [3. Run `Show-Karma` again to see how you did](#3-run-show-karma-again-to-see-how-you-did)
  - [Contributing](#contributing)
  - [Support the Project](#support-the-project)

## About the Author

### Joel Sallow

- [Blog](https://vexx32.github.io)
- [Twitter](https://twitter.com/vexx32)

## Synopsis

Inspired by Chris Marinos' **fantastic** [F# koans](https://github.com/ChrisMarinos/FSharpKoans), the goal of the PowerShell koans is to teach you PowerShell by presenting you with a set of questions.
Each [kōan](https://en.wikipedia.org/wiki/K%C5%8Dan) (each question) is represented by a failing Pester test.
Your goal is to make those tests pass by filling out the correct answer, or writing the correct code.
The koans start very simple to get you familiar with the basic concepts and progress towards more difficult.
Teaching you multiple beginner, intermediate and advanced aspects of PowerShell in the process.

To get started please navigate to [prerequisites](#prerequisites) and [getting started](#getting-started).

## Command Reference

View the PSKoans [Command Reference Documentation](docs/PSKoans.md).

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

```PowerShell
Install-Module PSKoans -Scope CurrentUser
```

### Or Download the Repo

1. `git clone` the repository into your desired directory, or download the module zip file from the build artifacts available on [this page](https://dev.azure.com/SallowCode/PSKoans/_build/latest?definitionId=1).
2. From a normal powershell session run `Get-ChildItem -Recurse | Unblock-File` in that directory to remove the "downloaded from internet" flag that blocks them from running.
3. Check `Get-ExecutionPolicy`: if it says 'Restricted' or 'Undefined', you need to also run `Set-ExecutionPolicy RemoteSigned` in order to allow the scripts to run.
4. Add the repository folder to `$env:PSModulePath` so that PowerShell can see it.
   - From the repository main folder, run: `$env:PSModulePath = "$(Get-Location)$([IO.Path]::PathSeparator)${env:PSModulePath}"`

## Start your Journey

### 1. Run `Show-Karma` to start your journey towards PowerShell enlightenment

You will be presented with a page describing your goal:

```code
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

Describing 'Equality' has damaged your karma.

    You have not yet reached enlightenment.

    The answers you seek...

Expected $true, but got $null.

    Please meditate on the following code:

× It is a simple comparison
at <ScriptBlock>, C:\Users\Joel\PSKoans\Introduction\AboutAssertions.Koans.ps1: line 27
27:         $____ | Should -Be $true

    ▌ When you smash the citadel of doubt,
    ▌ Then the Buddha is simply yourself.

    You examine the path beneath your feet...

 [AboutAssertions]: [――――――――――――――――――――――――――] 0/4


 [Total]: [――――――――――――――――――――――――――――――――――――――――――――――――――――] 0/635

Run 'Show-Karma -Meditate' to begin your meditations.
```

Inspect the red messages carefully, most importantly the last one.
The error message contains path to the file that you need to edit in order to progress forward.
In this case, you'll need to examine `Introduction\AboutAssertions.Koans.ps1`.

### 2. Run `Show-Karma -Meditate` to open your Koans folder

Navigate to `Introduction\AboutAssertions.Koans.ps1`. Near the top you'll see:

```powershell
It 'is a simple comparison' {
    # Some truths are absolute.
    $____ | Should -Be $true
}
```

The `$___` represents a blank for you to fill, and `| Should -Be $true` shows the expected result.
To pass this koan you need to replace `$____` with `$true` to fulfil the assertion: `$true | Should -Be $true`

### 3. Run `Show-Karma` again to see how you did

You passed your first koan!
You'll notice that your overall progress updated to `1/635` and you are presented with the next challenge.

```code
    Welcome, seeker of enlightenment.
    Please wait a moment while we examine your karma...

Describing 'Equality' has damaged your karma.

    You have not yet reached enlightenment.

    The answers you seek...

Expected 3, but got .

    Please meditate on the following code:

× It expects you to fill in values
at <ScriptBlock>, C:\Users\Joel\PSKoans\Introduction\AboutAssertions.Koans.ps1: line 32
32:         __ | Should -Be (1 + 2)

    ▌ Grasping nothing, discarding nothing.
    ▌ In every place there's no hindrance, no conflict.
    ▌ My supernatural power and marvelous activity:
    ▌ Drawing water and chopping wood.

    You examine the path beneath your feet...

 [AboutAssertions]: [■■■■■■――――――――――――――――――――] 1/4


 [Total]: [――――――――――――――――――――――――――――――――――――――――――――――――――――] 1/635

Run 'Show-Karma -Meditate' to begin your meditations.
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

## Support the Project

If you would like to support the project, you can:

- [Sponsor me on Github][github-sponsor]
- [Become a Patreon Patron][patreon]
- [Donate with Ko-fi][ko-fi]

[build-badge]: https://dev.azure.com/SallowCode/PSKoans/_apis/build/status/PSKoans%20CI
[build-link]: https://dev.azure.com/SallowCode/PSKoans/_build/latest?definitionId=1
[coverage-badge]: https://img.shields.io/azure-devops/coverage/SallowCode/PSKoans/1
[github-sponsor]: https://github.com/sponsors/vexx32
[patreon]: https://patreon.com/PSKoans
[ko-fi]: https://ko-fi.com/joelsallow
