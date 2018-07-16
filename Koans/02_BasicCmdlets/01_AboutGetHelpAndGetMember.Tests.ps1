<#
    Get-Help

    Get-Help is a built-in PowerShell cmdlet that is used to retrieve help data for
    cmdlets and functions. It contains usage examples, parameter information,
    and a significant amount of otherwise difficult to discover tidbits.

    Get-Member

    Get-Member is another built-in cmdlet that is invaluable in retrieving
    information about any object in PowerShell. It can be used to inspect the type
    name of an object, as well as all available methods and properties that can be
    accessed for that object.

    These cmdlets are quintessential discovery tools, and regular use of them will
    vastly expedite any unfamiliar task in PowerShell. Combined with well-placed
    Google searches, it is possible to learn a significant amount about native
    PowerShell cmdlets and functions, and more advanced .NET classes, and methods.
#>

Describe 'Get-Help' {

    Context 'shows help information about cmdlets' {
        # Try calling 'Get-Help Get-Help' in a console to see the built in help available
        # for the help command.

        It 'gives exhaustive information for cmdlets and functions' {
            $HelpInfo = Get-Help 'Get-Help'
            $GetHelpParams = $HelpInfo.Parameters.Parameter.Name

            # Using the information from Get-Help, fill in the missing parameters in alphabetical order.
            $GetHelpParams | Should -Be @(
                'Category'
                'Component'
                '__'
                'Examples'
                '__'
                '__'
                'Name'
                'Online'
                '__'
                'Path'
                'Role'
                '__'
            )
        }

        It 'can give detailed information on specific parameters' {
            # You can also query specific parameters for more detailed information on what they can do.
            # For instance, does the Path parameter for Get-Help support pipeline input?
            $ParameterInfo = Get-Help 'Get-Help' -Parameter Path
            $ParameterInfo.PipelineInput | Should -Be __
        }
        # Remember: if 'Get-Help Cmdlet-Name' doesn't show you all you need, try -Full. You'll need it.
    }
}

Describe 'Get-Member' {

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
            $PropertyName = '__'
            $String.$PropertyName | Should -Be 6
        }

        It 'can also find useful methods' {
            $String = "Methods are handy!"

            # Methods can be accessed just like properties, but have parentheses and often parameters!
            $String.EndsWith('__') | Should -BeTrue
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
            $MethodName = '__'
            $MethodArguments = @('__', '__')
            # The ForEach-Object cmdlet can be used to call methods as well.
            '7', '8', '9', '10' |
                ForEach-Object -MemberName $MethodName -ArgumentList $MethodArguments |
                Should -Be @('000007', '000008', '000009', '000010')
        }
    }

    Context 'Members of objects returned from cmdlets' {

        It 'can help you discover information about unfamiliar objects' {
            # Cmdlets also return objects! This cmdlet creates an empty .tmp file in a random location,
            # and returns the object representation of this file.
            $TempFile = New-TemporaryFile
            Test-Path -Path $TempFile.FullName | Should -BeTrue

            $TempFiles = 1..10 | ForEach-Object {
                New-TemporaryFile
            }

            # Which method can be used to remove these files?
            $MethodName = '__'
            $TempFiles | ForEach-Object $MethodName

            $TempFiles | Test-Path | Should -BeFalse
        }

        It 'actually returns objects itself' {
            $MemberData = 'string' | Get-Member
            # We can all betray our own selves.
            $MemberData | Should -BeOfType __
        }
    }
}