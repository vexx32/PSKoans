# Contributing to PowerShell Koans (PSKoans)

Welcome to PSKoans and thank you for your interest in contributing!

There are many ways that you can contribute, beyond writing or coding. The goal of this document is to provide a high-level overview of how you can get involved and how to interact.

## PSKoans Development Tools

If you want to contribute, at the very least, you'll need: 
- [ ] [A GitHub Account](http://github.com)

Here are a list of programs that should make contributing easier:
- [ ] [GitHub Desktop](https://desktop.github.com)
- [ ] [Visual Studio Code](https://code.visualstudio.com)

Some useful VSCode extensions are as follows:
- [ ] [PowerShell Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [ ] [Code Spell Checker Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

## PSKoans Development and Contribution Steps

1. Fork a copy of the [vexx32/PSKoans](https://github.com/vexx32/PSKoans) repository using your GitHub account
2. Clone your PSKoans fork locally to your computer
    > Tip: You may want to clone it to your OneDrive folder so that it's available on all your shared systems.
    1. This can be done either through Git directly or with GitHub Desktop.
1. Open and edit files and scripts using your preferred code Editor.
    > Tip: VSCode's PowerShell Extension is written by Microsoft so it is recommended.
1. Save your changes
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

## Question Declaration in Koan files

In PSKoans, each question requires the "Seeker of Enlightenment" to replace text which will allow the pester tests to pass successfully. 
The Following are a list of prompts that a Seeker might encounter.

__ = Answers that request int or double inputs (aka numeric). The standard will be **two**** underscores. 
'____' = Answers that request strings. The standard will be a **single quote** followed by **four** underscores** followed by a **single quote**.
"____" = Answers that request strings which **also** include Variables (aka $Variables). The standard will be a **double quote** followed by **four** underscores followed by a **double quote**. 
$____ = Answers that request variables (aka $Variables). The standard will be a dollar sign followed by **four** underscores.
____ = Answers that don't request anything else. The Default. The standard will be **four** underscores.

There are some questions that do not include any of the above prompts. These questions implicitly request the Seeker of Enlightenment to remove data that is already in place. In some instances there are comments announcing this fact, but in other there are not. 


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

### PSKoans Contribution Checklist
Please remember to do the following:

* [ ] **Search** the issue repository before submitting new issues
* [ ] **Recreate** the issue to ascertain if it is repeatable
* [ ] **Simplify** your scenario and isolate the problem if possible
* [ ] **Document** your findings by providing logs, log snippets and/or screen shots
* [ ] **Comment** add your comments and observations to existing issues
* [ ] **Vote** add your vote (via reactions) to existing issues
* [ ] **Track** your submission and monitor the submission workflow

# Thank You!
Your contributions and involvement will help to ensure the growth and success of PSKoans!
