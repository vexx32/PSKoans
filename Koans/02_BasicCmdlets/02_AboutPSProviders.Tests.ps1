<#
    PSProviders

    Providers are PowerShell's generial-purpose solution for accessing resources. The default set of
    providers that come with PowerShell on all platforms are listed below:

    Name                 Capabilities                            Drives
    ----                 ------------                            ------
    Alias                ShouldProcess                           {Alias}
    Environment          ShouldProcess                           {Env}
    FileSystem           Filter, ShouldProcess, Credentials      {/}
    Function             ShouldProcess                           {Function}
    Variable             ShouldProcess                           {Variable}

    Several are for accessing internal PowerShell resources (aliases, functions, variables), but the
    rest typically interact with the surrounding environment like the filesystem or OS environment.

    On Windows, PowerShell also comes with a Registry provider, for interacting with the Windows
    registry.

    All providers that have a defined function with the Get-Content cmdlet can also be accessed
    similarly to variable scopes, e.g., { $env:Path } instead of { Get-Content 'Env:Path' }
#>
Describe 'Alias:' {
    <#
        Aliases are PowerShell command shortcuts. By querying the Alias: provider, you can get a
        list of all command shortcuts in the current session. The available aliases may increase
        when a new module is imported.
    #>
    Context 'Direct Access' {

        It 'can be queried with generic provider cmdlets' {
            $Aliases = Get-ChildItem 'Alias:'

            $Aliases.Count | Should -Be __
            $Aliases.Name[0] | Should -Be __
            $Aliases.Definition[0] | Should -Be __
        }

        It 'maps aliases to the full command' {
            $Alias = '__'
            $AliasObject = Get-Item "Alias:\$Alias" -ErrorAction SilentlyContinue

            $AliasObject | Get-Content | Should -Be 'Set-Location'
        }

        It 'can create aliases too!' {
            New-Item -Name 'Alias:\grok' -Value 'Get-Item'
            $File = grok '__'

            $File | Should -BeOfType 'System.IO.FileInfo'
        }
    }

    Context 'Access Via Cmdlet' {

        It 'can be accessed with Get-Alias' {
            $AliasObjects = Get-ChildItem 'Alias:'
            $AliasObjects2 = Get-Alias

            $AliasObjects2.Count | Should -Be __
            $AliasObjects | Should -Be $AliasObjects2
        }

        It 'allows for seeking out aliases for a command' {
            $CmdletName = '__'
            $AliasData = Get-Alias -Definition $CmdletName

            $AliasData.Name | Should -Be 'gcm'
        }

        It 'can be used to find the exact command' {
            $AliasData = Get-Alias -Name 'ft'

            $AliasData.Definition | Should -Be '__'
        }

        It 'can create aliases too!' {
            Set-Alias -Name 'grok' -Value 'Get-Item'
            $File = grok '__'

            $File | Should -BeOfType 'System.IO.FileInfo'
        }
    }

    Context 'Variable Access' {

        It 'can be accessed like a variable' {
            $Alias:gci | Should -Be __
        }

        It 'is the same as using Get-Content on the path' {
            Get-Content -Path 'Alias:\gcm' | Should -Be $Alias:gcm
            Get-Content -Path 'Alias:\echo' | Should -Be __
        }
    }
}

Describe 'Environment' {
    <#
        The Env: drive contains system environment data. Its contents can vary wildly from OS to OS,
        especially between Windows, Mac, and Linux, for example.

        The only shared Env: items across all OS's currently are Path and PSModulePath.
    #>
    $EnvironmentData = Get-ChildItem -Path 'Env:'

    It 'allows access to system environment data' {
        $SelectedItem = $EnvironmentData.Where{ $_.Value -is [string] }[7]

        $SelectedItem | Get-Content | Should -Be '__'
        $SelectedItem.Name | Should -Be '__'
    }
}

Describe 'FileSystem' {

}

Describe 'Function' {

}

Describe 'Variable' {

}

Describe

Describe 'Registry' -Tag 'Windows' {

}


