# Contributing to PowerShell Koans (PSKoans)

Welcome to PSKoans and thank you for your interest in contributing!

There are many ways that you can contribute, beyond writing or coding. The goal of this document is to provide a high-level overview of how you can get involved and how to interact.

## Table of Contents

- [Contributing to PSKoans](#contributing-to-powershell-koans-(pskoans))
  - [Table of Contents](#table-of-contents)
  - [Asking Questions](#asking-questions)
  - [Providing Feedback](#providing-feedback)
  - [Reporting Issues](#reporting-issues)
  - [Check for existing issues first](#check-for-existing-issues-first)
    - [Submitting Bug Reports and Feature Requests](#submitting-bug-reports-and-feature-requests)
  - [Contributing](#contributing)
      - [PSKoans Contribution Checklist](#pskoans-contribution-checklist)
      - [PSKoans Development Tools](#pskoans-development-tools)
      - [PSKoans Development Setup and Operation](#pskoans-development-setup-and-operation)
        - [GitHub Desktop](#github-desktop)
        - [PowerShell Git](#powershell-git)
        - [VSCode](#vscode)
      - [Question Declaration in Koan files](#question-declaration-in-koan-files)
      - [Writing Koans](#writing-koans)
- [Thank You!](#thank-you!)



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
- [ ] [PowerShell Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [ ] [PowerShell Preview Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell-Preview)
- [ ] [Code Spell Checker Extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)

### PSKoans Development Setup and Operation

These steps will be laid out using a few different approaches

#### Github Desktop
1. Fork the Repository
    - Go to https://github.com/vexx32/PSKoans and click the Fork button at the top right hand side of the page. 
2. Setup
    - Download and Install [GitHub Desktop](https://desktop.github.com)
    - Sign in to GitHub Desktop with your GitHub account information
    - Configure Git by entering the name and email address you want to make commits with.
3. Clone Repository
    - Option 1
        - On your forked repository page (it should be https://github.com/$YOURNAME/PSKoans), click the green "Clone or download" button and then click "Open in Desktop"
    - Option 2
        - Open Desktop and click "Clone a repository from the Internet..."
        - You should see your repositories and should choose the fork you just created.
        - alternatively, you can hit the URL tab and paste in your URL (https://github.com/$YOURNAME/PSKoans)
4. Make Changes!
    - Fix some bugs, write some code! Save your work!
5. Commit
    - Committing saved changes to current branch
        - Once you've made a change and saved it, GitHub Desktop will show the diffs 
        - Enter a Summary and Description of your commit and then hit "Commit to master"
            - This with add the changes to a commit on your master branch of your local git copy.
6. Push Origin 
    - Hit the "Push origin" button in GitHub Desktop to merge your local repository copy with the copy stored on GitHub.
7. Pull Request
    - Option 1
        - From GitHub Desktop, click the blue "Create Pull Request" button that appears after you hit "Push origin"
        - This will take you to the "Open a pull request" GitHub page comparing your repo / branch against the PSKoans / master branch
    - Option 2
        - Go to Github and do a pull request from the PSKoans main page. the process is the same!
8. Collaborate and have your change approved and merged into the main branch!

#### PowerShell Git
1. Fork the Repository
    - Go to https://github.com/vexx32/PSKoans and click the Fork button at the top right hand side of the page. 
2. Setup
    - Download and Install [Git](https://git-scm.com/downloads)
        - The only non-default you may want is selecting which editor you want to use as your default.
    - Configure the username you will use for your commit messages.
        - from powershell type: `git config --global user.name "Username"`
    - Configure the email address you will use for your commit messages.
        - from powershell type: `git config --global user.email emailname@email.address` 
    - Git is now set up!
3. Clone Repository
    - Create a folder where you would like to put your local repository and Change your PowerShell directory to that location
    - Find the URL of your fork and run: `git clone https://github.com/$YOURNAME/PSKoans`
        - This will make a local copy of your fork. 
4. Make Changes!
    - Fix some bugs, write some code! Save your work!
5. Commit
    - Committing saved changes to current branch
        - Committing changes with git directly is a little more work. 
        - Run: `git add file.ps1 file2.ps1`
            - This adds the files to the next commit you run, as by default no files are included.
        - Run: `git commit -m "commit summary" -m "commit description"`
            - This takes the files that you ran `git add` against and commits them to your local git repo with -m for your message. 
6. Push Origin 
    - Check what your origin is by Changing your directory to your repository and running: `git remote -v`
        - This should display `origin https://github.com/$Username/PSKoans`
    - Push 
        - Run: `git push origin master` to push your local repo commits to your Github repo. 
            - Running this command will pop up a dialog box to log into GitHub to authenticate your push. 
7. Pull Request
    - Go to Github and do a pull request from the PSKoans main page.
8. Collaborate and have your change approved and merged into the main branch!

#### VSCode
1. Fork the Repository.
    - Go to https://github.com/vexx32/PSKoans and click the Fork button at the top right hand side of the page.
2. Setup.
    - Download and Install [VSCode](https://desktop.github.com).
    - Download and Install [Git](#powershell-git) (Follow the setup instructions from the git setup).
3. Clone Repository.
    - Follow the options from either [GitHub Desktop](#github-desktop) or [PowerShell Git](#powershell-git).
4. Make Changes!
    - Fix some bugs, write some code! Save your work!
5. Commit.
    - Hit the "Source Control" button on the left hand side of the VSCode window.
    - Stage your changes.
        - Hit the ➕ on the right side of the files you want to commit.
    - Add a commit message in the "message" box.
    - Hit the ✔️ above the files to commit them to the local repo. 
6. Push Origin 
    - In the lower left hand corner you should see 0⬇️1⬆️ 
    - This will push your commits up to the master branch of your fork. 
7. Pull Request
    - Go to Github and do a pull request from the PSKoans main page.
8. Collaborate and have your change approved and merged into the main branch!
        

Your submissions and contributions will be reviewed and processed by the PSKoans Code Owners. You will receive notifications in the GitHub tools as well as the email account used for GitHub.

### Question Declaration in Koan files

In PSKoans, each question requires the "Seeker of Enlightenment" to replace text which will allow the pester tests to pass successfully. 
The following are a list of prompts that a Seeker might encounter.

`__`= Answers that request int or double inputs (aka numeric). The standard will be **two underscores**.

`'____'` = Answers that request string inputs. The standard will be a **single quote** followed by **four underscores** followed by a **single quote**.

`"____"` = Answers that request string inputs which **also** include Variables (aka $Variables). The standard will be a **double quote** followed by **four underscores** followed by a **double quote**.

`$____` = Answers that request variable inputs (aka $Variables). The standard will be a **dollar sign** followed by **four underscores**.

`____` = General-purpose usage. This could be a command name, a hashtable key name, or a parameter argument that expects a string. Any place a bare string is a valid answer, this should be used. Use **four underscores** for bare string blanks.

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


# Thank You!
Your contributions and involvement will help to ensure the growth and success of PSKoans!

