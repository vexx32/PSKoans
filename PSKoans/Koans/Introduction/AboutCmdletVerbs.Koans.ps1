using module PSKoans
[Koan(Position = 105)]
param()
<#
    Cmdlet Verbs

    The fundamental building block of PowerShell are cmdlets and functions, both
    of which are named according to a Verb-Noun syntax by convention.

    You can see the list of PowerShell's recommended / approved verbs by calling
    Get-Verb in your PowerShell console, or going to the following docs page:
    https://docs.microsoft.com/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands

    Each command should use a verb appropriate to the action it's taking, and a
    noun that succinctly and clearly describes what it's acting upon.

    In this topic, we'll cover the a few of the most common verbs which you'll
    see most frequently.
#>

Describe "Basic Verbs" {

    Context "Get" {
        <#
            Cmdlets with the Get verb are used for retrieving data.

            So for example "Get-Process" will retrieve all the processes running
            on your current machine.
        #>

        It 'is for commands that retrieve data' {
            <#
                Using the Get-Command cmdlet, which retrieves all available
                commands, find 5 commands with the Get verb.

                Fill in each blank with the name of a different Get-* command.
            #>
            $Answers = @(
                "____"
                "____"
                "____"
                "____"
                "____"
            )
            $Answers | Should -BeIn (Get-Command -Verb Get).Name

            $Answers |
                Get-Unique |
                Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "New" {
        <#
            Cmdlets with the New verb are used to create data.

            So for example 'New-Guid' will create a new GUID, or 'New-TimeSpan'
            will create a new [timespan] object with the specified parameters.
        #>

        It 'is for commands that create data' {
            <#
                Using Get-Command, find 5 commands with the New verb.

                Replace each ____ with the name of a New-* command.
            #>
            $Answers = @(
                "____"
                "____"
                "____"
                "____"
                "____"
            )
            $Answers | Should -BeIn (Get-Command -Verb New).Name

            $Answers |
                Get-Unique |
                Should -HaveCount 5 -Because "five unique cmdlets are required"
        }

        It 'can create a New-Item' {
            <#
                Let's try creating a file!

                $Path = "YOUR PATH.txt"
                New-Item -Path $Path -ItemType file

                This will create a new text file, in the location you specify.
                In this case, we'll
            #>

            $File
        }
    }

    Context "Add" {
        <#
            Cmdlets with the Add verb append data to an existing object or data
            source.

            If you followed the example in the 'new' test, you can use
            Add-Content to add some text to your newly created text file:

                $Path = "YOUR PATH.txt"
                $text = "Sgt. Bash is the best house robot because... fire."
                Add-Content -Path $Path -Value $text

            Before continuing, run this command several times. See what happens;
            is it the result you expected?

            You'll see that several lines of text were added to the file. This
            cmdlet only appends information, it does not overwrite.

            Essentially, if the target doesn't exist then a cmdlet with the Add
            verb will typically create it. If it does exist, the cmdlet will
            add data to it, if data can be added without overwriting the
            original data.

            A common example one might see working with Office 365 is calendar
            permissions. If you want to grant permissions to somebody who
            doesn't have any, you use "Add-MailboxFolderPermission".
        #>

        It 'is for commands that append data' {
            <#
                Using Get-Command, find 5 commands with the Add verb.

                Replace each ____ with the name of an Add-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Add).Name

            $Answers |
                Get-Unique |
                Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "Set" {
        <#
            Cmdlets with the Set verb will overwrite information that already
            exists.

            If you followed the example in the 'New' and 'Add' tests, you can
            use set to do something to your text file:

                $Path = "YOUR PATH.txt"
                $text = "Sir Kill-A-Lot is the best house robot because of reasons."
                Set-Content -Path $Path -Value $text

            Before continuing, run this command several times. See what happens;
            is it the result you expected?

            You'll see that there's only one line of text in the file. This is
            because the Set-Content command will overwrite information that's
            already there.

            Some Set-* cmdlets require the instance to already be present for
            you to change it; you'll need to use a New-* cmdlet first to create
            an instance before you can overwrite information within it.

            A common example one may see working with Office 365 is with
            calendar permissions. If a user already has some permissions
            configured, you can use "Set-MailboxFolderPermission" to change the
            user's permissions.
        #>

        It 'is for commands that overwrite data' {
            <#
                Using Get-Command, find 5 commands with the Set verb.

                Replace each ____ with the name of a Set-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Set).Name

            $Answers |
                Get-Unique |
                Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "Remove" {
        <#
            Cmdlets with the Remove verb will delete data from an object or data
            source.

            If you followed the example in the 'New','Add' and 'Set' tests, you
            can use Remove-Item to delete your text file:

                $Path = "YOUR PATH.txt"
                Remove-Item -Path $Path

            Before continuing, run this command a few times. What happens when
            you try to run it once the item has been deleted?

            You'll see that it fails. Cmdlets with the verb Remove simply remove
            data; if the instance you're referring to doesn't exist, then
            there's nothing available to remove and it will emit an error
            message.

            Returning to Calendar permissions in Office 365, you can use a
            Remove cmdlet to completely remove a user's permissions to a
            calendar.
        #>

        It "is for commands that delete data" {
            <#
                Using Get-Command, find 5 commands with the Remove verb.

                Replace each ____ with the name of a Remove-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Remove).Name

            $Answers |
                Get-Unique |
                Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }
}
