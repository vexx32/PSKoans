using module PSKoans
[Koan(Position = 105)]
param()
<#
    Cmdlet Verbs

    The fundamental building block of PowerShell are cmdlets and functions.

    We'll cover functions later, but cmdlets are made up of the following syntax:

        Verb-Noun

    With the verb being an action, and the noun representing the target of the command.

    In this topic, we'll cover the 5 basic verbs which'll see you through the majority of your
    PowerShell needs. But PowerShell has more than just 5 predefined verbs! You can see them
    all by running the following cmdlet:

        Get-Verb
#>

Describe "Basic Verbs" {

    Context "Get" {
        <#
            Cmdlets with the Get verb are used for retrieving data.

            So for example "Get-Process" will retrieve all the processes running on
            your current machine.
        #>

        It 'is for commands that retrieve data' {
            <#
                Using the Get-Command cmdlet, which retrieves all available commands,
                find 5 commands with the Get verb.

                Replace each ____ with the name of a Get-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Get).Name

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "New" {
        <#
            Cmdlets with the New verb are used to create data.

            So for example 'New-GUID' will create a new GUID, or 'New-LocalUser' will create a local
            user on your machine.

            Before continuing with this exercise, try using the following code to create a file:

                $Path = "YOUR PATH.txt"
                New-Item -Path $Path -ItemType file

            This will create a new text file, in the location you specify.
        #>

        It 'is for commands that create data' {
            <#
                Using Get-Command, find 5 commands with the New verb.

                Replace each ____ with the name of a New-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb New).Name

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "Add" {
        <#
            Cmdlets with the Add verb append data to an existing object or data source.

            If you followed the example in the 'new' test, you can use Add-Content to add some
            text to your newly created text file:

                $Path = "YOUR PATH.txt"
                Add-Content -Path $Path -Value "Sgt. Bash is the best house robot because... fire."

            Before continuing, run this command several times. See what happens; is it the
            result you expected?

            You'll see that several lines of text were added to the file. This cmdlet only appends
            information, it does not overwrite.

            Basically, if it doesn't exist then a cmdlet with the add verb can probably be used
            to make it so.

            A common example one might see working with Office 365 is calendar permissions.
            If you want to grant permissions to somebody who doesn't have any, you use "Add-MailboxFolderPermission".
        #>

        It 'is for commands that append data' {
            <#
                Using Get-Command, find 5 commands with the Add verb.

                Replace each ____ with the name of an Add-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Add).Name

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "Set" {
        <#
            Cmdlets with the Set verb will overwrite information that already exists.

            If you followed the example in the 'New' and 'Add' tests, you can use set to do
            something to your text file:

                $Path = "YOUR PATH.txt"
                Set-Content -Path $Path -Value "Sir Kill-A-Lot is the best house robot because of reasons."

            Before continuing, run this command several times. See what happens, is it the
            result you expected?

            You'll see that there's only one line of text in the file. This is because the Set-Content command
            will overwrite information that's already there.

            Some Set-* cmdlets require the instance to already be present for you to change it;
            you'll need to use a New-* cmdlet first to create an instance before you can
            overwrite information within it.

            A common example one may see working with Office 365 is with calendar permissions.
            If a user already has some permissions configured, you can use you use "Set-MailboxFolderPermission"
            to change the user's permissions. However, attempting to use an Add cmdlet will fail;
            Set-* commands overwrite data, but often can only do so if it already exists.

        #>

        It 'is for commands that overwrite data' {
            <#
                Using Get-Command, find 5 commands with the Set verb.

                Replace each ____ with the name of a Set-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Set).Name

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }

    Context "Remove" {
        <#
            Cmdlets with the Remove verb will delete data from an object or data source.

            If you followed the example in the 'New','Add' and 'Set' tests, you can use Remove-Item to
            delete your text file:

                $Path = "YOUR PATH.txt"
                Remove-Item -Path $Path

            Before continuing, run this command a few times. What happens when you try to run it
            once the instance has been deleted?

            You'll see that it fails. Cmdlets with the verb Remove simply remove data;
            if the instance you're referring to doesn't exist, then there's nothing available
            to remove and it will emit an error message.

            Returning to Calendar permissions in Office 365, you can use a Remove cmdlet
            to completely remove a user's permissions to a calendar.
        #>

        It "is for commands that delete data" {
            <#
                Using Get-Command, find 5 commands with the Remove verb.

                Replace each ____ with the name of a Remove-* command.
            #>
            $Answers = "____", "____", "____", "____", "____"
            $Answers | Should -BeIn (Get-Command -Verb Remove).Name

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }
    }
}
