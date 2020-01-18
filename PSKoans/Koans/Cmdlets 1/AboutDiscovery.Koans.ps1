using module PSKoans
[Koan(Position = 201)]
param()
<#
    Help & Discovery

    PowerShell's help and discovery systems are a key component to its ecosystem. A great
    many things can be learned simply by knowing where to look and which few cmdlets to
    use in order to find what you're looking for.

    Discovery cmdlets are quintessential learning tools, and regular use of them will
    vastly expedite any unfamiliar task in PowerShell. Combined with targeted online
    searches, it is straightforward to learn a significant amount about native PowerShell
    cmdlets and functions, as well as more advanced .NET classes, and methods.
#>
Describe 'Get-Help' {
    <#
        Get-Help

        Get-Help is a built-in PowerShell cmdlet that is used to retrieve help data for
        cmdlets and functions. It contains usage examples, parameter information, and
        a significant amount of otherwise difficult to discover tidbits.
    #>
    Context 'shows help information about cmdlets' {
        <#
            Try calling 'Get-Help Get-Help' in a console to see the built in help available
            for the help command.
        #>

        It 'gives exhaustive information for cmdlets and functions' {
            $HelpInfo = Get-Help 'Get-Help'
            $GetHelpParams = $HelpInfo.Parameters.Parameter.Name

            <#
                Using the information from Get-Help, fill in a few of the available parameter names for the cmdlet.
                Note that the specific parameters available may depend on your version of PowerShell.
            #>
            $ParamNames = @(
                '____'
                'Examples'
                '____'
                '____'
                'Online'
                '____'
            )

            $ParamNames |
                Group-Object |
                Where-Object Count -gt 1 |
                Should -BeNullOrEmpty -Because 'you need to enter unique parameter names'

            $ParamNames | Should -BeIn $GetHelpParams
        }

        It 'can give detailed information on specific parameters' {
            # You can also query specific parameters for more detailed information on what they can do.
            # For instance, does the Path parameter for Get-Help support pipeline input?
            $ParameterInfo = Get-Help 'Get-Help' -Parameter Path
            $____ | Should -Be $ParameterInfo.PipelineInput
        }
        <#
            Remember: if 'Get-Help Cmdlet-Name' doesn't show you all you need, try -Full.
            You can also search for commands with a certain parameter using Get-Help:

                Get-Help -Name * -Parameter ComputerName
        #>
    }
}

Describe 'Get-Member' {
    <#
        Get-Member

        Get-Member is another built-in cmdlet that is invaluable in retrieving
        information about any object in PowerShell. It can be used to inspect the type
        name of an object, as well as all available methods and properties that can be
        accessed for that object.
    #>
    Context 'Members and methods of objects' {

        It 'can help you find useful properties' {
            $String = 'Hello!'

            # If you try to access a property that doesn't exist, PowerShell returns $null for it.
            $String.ThisDoesntExist | Should -Be $null
            <#
                To use Get-Member, pipe an object into it like so:
                    "Hello!" | Get-Member

                You may need to try some of these in a PowerShell console for yourself to find the best
                way to solve the problem! Tab-completion can also help you find method and property
                names; try typing 'string'.<tab> into a console and cycling through the suggested
                properties and methods.

                Which property of the above string has the expected value?
            #>
            $PropertyName = '____'
            $String.$PropertyName | Should -Be 6
        }

        It 'can also find useful methods' {
            $String = "Methods are handy!"

            # Methods can be accessed just like properties, but have parentheses and often parameters!
            $String.EndsWith('____') | Should -BeTrue
            <#
                If you have trouble figuring out which parameters a method requires, you can check the
                OverloadDefinitions by calling the method name without the parentheses. For the above
                method, these look like this:

                PS> 'string'.EndsWith

                OverloadDefinitions
                -------------------
                bool EndsWith(string value)
                bool EndsWith(string value, System.StringComparison comparisonType)
                bool EndsWith(string value, bool ignoreCase, cultureinfo culture)

                Note that each overload is separate, and mentions what object type it returns first,
                followed by the type and number of arguments it will accept. Only one overload can
                be used at a time, and usually the number of arguments and type of the arguments
                determine the overload that PowerShell will apply when calling the method.
            #>
            $MethodName = '____'
            $MethodArguments = @('____', '____')
            # The ForEach-Object cmdlet can be used to call methods as well.
            '7', '8', '9', '10' |
                ForEach-Object -MemberName $MethodName -ArgumentList $MethodArguments |
                Should -Be @('000007', '000008', '000009', '000010')
        }
    }

    Context 'Members of objects returned from cmdlets' {

        It 'can help you discover information about unfamiliar objects' {
            <#
                Cmdlets also return objects! This cmdlet creates an empty .tmp file in a random
                location, and returns the object representing this file.
            #>
            $TempFile = New-TemporaryFile
            Test-Path -Path $TempFile.FullName | Should -BeTrue

            $TempFiles = 1..10 | ForEach-Object {
                New-TemporaryFile
            }

            # Which method can be used to remove these files?
            $MethodName = '____'
            $TempFiles | ForEach-Object $MethodName

            $TempFiles | Test-Path | Should -BeFalse
        }

        It 'actually returns objects itself' {
            $MemberData = 'string' | Get-Member
            # We can all betray our own selves.
            $MemberData | Should -BeOfType ____
        }
    }
}

Describe 'Get-Command' {
    <#
        Get-Command

        Get-Command is one of the most useful cmdlets for discovery. It allows you to
        list all available commands, specify a module to look for available commands in,
        and filter based on command name, module name, etc.

        As the vast majority of PowerShell commands are packaged with help files, it is
        also an invaluable tool in finding possible help topics to look up in the first
        place!

        When looking for related commands, use of the -Verb and -Noun search options
        is often easier than figuring out how many wildcards you need in a -Name search.
    #>

    It 'lists available commands' {
        # Try calling Get-Command in a PowerShell console to see the typical output!
        $CommandCount = Get-Command | Measure-Object | Select-Object -ExpandProperty Count
        __ | Should -Be $CommandCount
        Get-Command | Select-Object -First 1 -ExpandProperty Name | Should -Be '____'
    }

    It 'indicates the type of command' {
        $CommandType = Get-Command | Select-Object -Skip 3 -First 1 -ExpandProperty CommandType

        '____' | Should -Be $CommandType
    }

    It 'can filter the output by keywords' {
        $Command = Get-Command -Name "*-Child*" | Select-Object -First 1

        $Command.CommandType | Should -Be 'Cmdlet'
        '____' | Should -Be $Command.Name

        $CimCommand = Get-Command -Name '____'
        $CimCommand.Name | Should -Be 'Write-Information'
    }

    It 'can look for commands by verb' {
        $GetCommands = Get-Command -Verb 'Get'
        __ | Should -Be $GetCommands.Count

        '____' | Should -Be $GetCommands[4].Name
    }

    It 'can look for commands by noun' {
        $DateCommands = Get-Command -Noun 'Date'

        __ | Should -Be $DateCommands.Count
        '____' | Should -Be $DateCommands[0].Name
    }

    It 'can look for commands by module' {
        $KoanCommands = Get-Command -Module 'PSKoans' |
            Sort-Object -Property Name
        $First4Commands = $KoanCommands | Select-Object -First 4

        __ | Should -Be $KoanCommands.Count
        @('____', '____', '____', '____') | Should -Be $First4Commands.Name
    }
}
