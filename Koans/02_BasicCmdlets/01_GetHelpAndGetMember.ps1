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

        It "gives exhaustive information for cmdlets and functions" {
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
        It "can give detailed information on specific parameters" {
            # You can also query specific parameters for more detailed information on what they can do.
            # For instance, does the Path parameter for Get-Help support pipeline input?
            $ParameterInfo = Get-Help 'Get-Help' -Parameter Path
            $ParameterInfo.PipelineInput | Should -Be __
        }
        # Remember: if 'Get-Help Cmdlet-Name' doesn't show you all you need, try -Full. You'll need it.
    }
}
Describe 'Get-Member' {
    It 'displays the members and methods of objects' {

    }
}