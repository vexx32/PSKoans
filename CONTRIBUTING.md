# Contributing to PowerShell Koans (PSKoans)

Welcome to PSKoans and thank you for your interest in contributing!

There are many ways that you can contribute, beyond writing or coding. The goal of this document is to provide a high-level overview of how you can get involved and how to interact.

## Table of Contents

- [Contributing to PSKoans](#contributing-to-powershell-koans-(pskoans))
    -[Table of Contents](#table-of-contents)
    -[Asking Questions](#asking-questions)
    -[Providing Feedback](#providing-feedback)
    -[Reporting Issues](#reporting-issues)
    -[Check for existing issues first](#check-for-existing-issues-first)
        -[Submitting Bug Reports and Feature Requests](#submitting-bug-reports-and-feature-requests)
    -[Contributing](#contributing)
        -[PSKoans Contribution Checklist](#pskoans-contribution-checklist)
        -[PSKoans Development Tools](#pskoans-development-tools)
        -[PSKoans Development and Contribution Steps](#pskoans-development-and-contribution-steps)
        -[Question Declaration in Koan files](#question-declaration-in-koan-files)
        -[Writing Koans](#writing-koans)
-[Thank You!](#thank-you!)



## Asking Questions

Have a question? Open an new issue using relevant labels. The community will be eager to assist you. Your well-worded question will serve as a resource to others searching for help.

## Providing Feedback

Your comments and feedback are welcome, and the PSKoans team is monitoring this GitHub regularly.

## Reporting Issues 

Please share any of the following:
- Reproducible problem(s) 
- Feature request(s) 
- Comments, observations, notations, etc.

## Check for existing issues first 

- Enter and monitor PSKoans issues via the [PSKoans GitHub Issues tab](https://github.com/vexx32/PSKoans/issues). You can sort by author, contributor, label (class), and more here.
- Before you begin creating new issues, search first! Be sure to check out the [Advanced Search](https://github.com/search/advanced) features of GitHub
- If you find your issue already exists, contribute relevant comments and add your reaction
    > ProTip: Use a **reaction** response rather than "+1" in a comment field
    * 👍 -> UpVote
    * 👎 -> DownVote

If you cannot find an existing issue similar to your bug or feature, create a **new** issue using the guidelines below.

### Submitting Bug Reports and Feature Requests
n
- Please only one issue or feature request per submission. 
- Do **not** enumerate multiple bugs or feature requests in the same issue.
- Do not add your issue as a comment to an existing issue unless it's for the identical input. 
- Many issues look similar, but may have different causes.
- More information is better, provide sufficient details to reproduce or narrow down the problem. 

## Contributing

We have a great many topics to cover, including the near-infinite slew of PowerShell cmdlets that _all_ deserve koan coverage.
Naturally, we're happy to accept any and _all_ help that comes our way!

There are two main ways you can contribute:

1. Feel more than free to clone the repository, make some changes, and submit a pull request!
2. Submit any small changes you'd like make to any of the koans as an issue on the repository, and either myself or one of the helpers here will be happy to talk it over and get it sorted out.

### PSKoans Contribution Checklist
Please remember to do the following:

* [ ] **Search** the issue repository before submitting new issues
* [ ] **Recreate** the issue to ascertain if it is repeatable
* [ ] **Simplify** your scenario and isolate the problem if possible
* [ ] **Document** your findings by providing logs, log snippets and/or screen shots
* [ ] **Comment** add your comments and observations to existing issues
* [ ] **Vote** add your vote (via reactions) to existing issues
* [ ] **Track** your submission and monitor the submission workflow

### PSKoans Development Tools

If you want to contribute, at the very least, you'll need: 
- [ ] [A GitHub Account](http://github.com)

Here are a list of programs that should make contributing easier:
- [ ] [GitHub Desktop](https://desktop.github.com)
- [ ] [Visual Studio Code](https://code.visualstudio.com)

Some useful VSCode extensions are as follows:
- [ ] [PowerShell Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [ ] [Code Spell Checker Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

### PSKoans Development and Contribution Steps

1. Fork a copy of the [vexx32/PSKoans](https://github.com/vexx32/PSKoans) repository using your GitHub account
2. Clone your PSKoans fork locally to your computer
    > Tip: You may want to clone it to your OneDrive folder so that it's available on all your shared systems.
    1. This can be done either through Git directly or with GitHub Desktop.
1. Open and edit files and scripts using your preferred code Editor.
    > Tip: VSCode's PowerShell Extension is written by Microsoft so it is recommended.
1. Save your changes.
1. When ready to upload, 
    - open GitHub Desktop and your repository
    - Update the **Summary** input field (lower left)
    - Update the **Description** input field (lower left)
    - Click on **Commit to Master** (lower left)
        > Tip: This saves your commit to your ***Local*** fork of PSKoans
    - Click on **Push origin** to push your changes upstream
        > Tip: This pushes your commit from your local fork, to your fork on GitHub. 
1. Open GitHub Desktop to your PSKoans repository
    - Click on Repository -> View on GitHub
1. Generate a Pull Request
    - Click on **Create Pull Request**
        > Tip: This can be done from the webpage or directly from GitHub Desktop.
        >> Tip: Creating a pull request creates a request to import your version of changes to where you forked your repository from, also know as the ***Upstream*** repository. 
        

Your submissions and contributions will be reviewed and processed by the PSKoans Code Owners. You will receive notifications in the GitHub tools as well as the email account used for GitHub.

### Question Declaration in Koan files

In PSKoans, each question requires the "Seeker of Enlightenment" to replace text which will allow the pester tests to pass successfully. 
The following are a list of prompts that a Seeker might encounter.

`__`= Answers that request int or double inputs (aka numeric). The standard will be **two underscores**.

`'____'` = Answers that request string inputs. The standard will be a **single quote** followed by **four underscores** followed by a **single quote**.

`"____"` = Answers that request string inputs which **also** include Variables (aka $Variables). The standard will be a **double quote** followed by **four underscores** followed by a **double quote**.

`$____` = Answers that request variable inputs (aka $Variables). The standard will be a **dollar sign** followed by **four underscores**.

`____` = Answers that don't request any of the above options. If this were a Switch Statement, this would be the Default case. The standard will be **four underscores**.

There are some questions that do not include any of the above prompts. These questions implicitly request the Seeker of Enlightenment to remove data that is already in place to pass the test. In some instances there are comments announcing this fact, but in other there are not. 

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

[build-badge]: https://dev.azure.com/SallowCode/PSKoans/_apis/build/status/PSKoans%20CI
[build-link]: https://dev.azure.com/SallowCode/PSKoans/_build/latest?definitionId=1

# Thank You!
Your contributions and involvement will help to ensure the growth and success of PSKoans!

