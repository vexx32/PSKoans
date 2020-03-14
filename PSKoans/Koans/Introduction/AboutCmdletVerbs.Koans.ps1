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

    In this topic, we'll cover a few of the most common verbs which you'll see
    most frequently.
#>

Describe "Basic Verbs" {

    BeforeAll {
        # We'll be using this path later on.
        $FilePath = "$env:TMP/YOUR_PATH.txt"

        if (Test-Path $FilePath) {
            Remove-Item -Path $FilePath
        }
    }

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

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
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

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }

        It 'can create a New-Item' {
            <#
                Let's try creating a file!

                Use New-Item to create a new text file, in the location
                specified with the $FilePath variable, which is defined above.

                The necessary parameters are already filled in for you here. In
                this case, the file we're creating is simply empty. You could
                also specify a -Value parameter with some text to put in the
                newly-created file.

                Take some time to experiment with New-Item in your console if
                you'd like to see what it can do! Start with:

                    Get-Command New-Item -Syntax
                    Get-Help New-Item -Examples
            #>

            $File = ____ -Path $FilePath -ItemType File

            # All "file" objects are of this type.
            $File | Should -BeOfType [System.IO.FileInfo]

            # An empty file has a "length" of zero.
            $File.Length | Should -Be 0
        }
    }

    Context "Add" {
        <#
            Cmdlets with the Add verb append data to an existing object or data
            source.

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

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }

        It 'can Add-Content to a file' {
            <#
                Try adding this content to the file we created above using
                Add-Content.
            #>
            "Mountains are merely mountains." | ____ -Path $FilePath

            <#
                Let's see what happens if we add a whole bunch of things! Fill
                in these blanks with whatever you like.
            #>

            '____' | Add-Content -Path $FilePath
            '____' | Add-Content -Path $FilePath
            '____' | Add-Content -Path $FilePath
            '____' | Add-Content -Path $FilePath

            # Let's check the contents of the file.
            $FileData = Get-Content -Path $FilePath

            # How many lines did we end up with?
            __ | Should -Be $FileData.Count

            <#
                We can see that several lines of content were added to the file.
                Add-* cmdlets can only append data, they can't overwrite. With
                this information, you should be able to determine what the
                expected content of the file is at this point.
            #>

            $ExpectedContent = @(
                'Mountains are merely mountains.'
                '____'
                '____'
                '____'
                'The road onwards, the road back; which is the shorter?'
            )

            $ExpectedContent | Should -BeExactly $FileData
        }
    }

    Context "Set" {
        <#
            Cmdlets with the Set verb will overwrite information that already
            exists.

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

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }

        It 'can Set-Content for a file' {
            <#
                Let's try using Set-Content on our text file from before. But
                first, let's check that it still has the contents we added. We
                should still have 5 lines in it from before.

                If you added extra lines to the file in the Add-Content koan
                above, make sure to update the expected line count here!
            #>
            $LineCount = 5
            Get-Content -Path $FilePath | Should -HaveCount $LineCount

            # Now let's try setting the contents.
            "Wherever you are, it's the place you need to be." | Set-Content -Path $FilePath

            # So what should be in the file now?
            $FileContent = Get-Content -Path $FilePath
            "____" | Should -BeExactly $FileContent

            # What happens if we set the contents again?
            '____' | Set-Content -Path $FilePath
            Get-Content -Path $FilePath | Should -BeExactly "Rest and be kind, you don't have to prove anything."
            <#
                You'll see that there's only one line of text in the file. This
                is because the Set-Content command will completely overwrite
                whatever is in the file already.
            #>
        }
    }

    Context "Remove" {
        <#
            Cmdlets with the Remove verb will delete data from an object or data
            source.

            Once again with calendar permissions in Office 365, you can use a
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

            $Answers | Get-Unique | Should -HaveCount 5 -Because "five unique cmdlets are required"
        }

        It 'can Remove-Item to delete a file' {
            <#
                    We can use Remove-Item to delete the text file we've been
                    working with. Before we do, let's just double check the file
                    still exists. 'Leaf' here refers to a file; 'Container'
                    would be the corresponding type for a folder.
                #>
            Test-Path $FilePath -PathType Leaf | Should -BeTrue

            # Pester has its own way of checking that files exist.
            $FilePath | Should -Exist

            # Use Remove-item to delete the file completely.
            ____ -Path $FilePath

            # Let's check it was removed properly.                Test-Path $FilePath -PathType Leaf | Should -BeTrue
            Test-Path $FilePath | Should -BeFalse

            <#
                    If we try to remove a file that doesn't exist, we should get
                    an error. What does that error look like?
                #>
            $Message = "____"
            { Remove-Item -Path $FilePath -ErrorAction Stop } | Should -Throw -ExpectedMessage $Message
        }
    }
}
