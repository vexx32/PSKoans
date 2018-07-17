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
#>
Describe 'Alias' {

}

Describe 'Environment' {

}

Describe 'FileSystem' {

}

Describe 'Function' {

}

Describe 'Variable' {

}

Describe 'Registry' -Tag 'Windows' {

}


