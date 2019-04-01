using module PSKoans
[Koan(Position = 400)]
param()
<#
    Out-* Cmdlets

    The 'Out' verb is defined in PowerShell simply as 'sends data out of the environment'. As that would
    lead you to believe, in most cases these commands cause the data to completely exit the PowerShell
    session, usually into some external storage or resource.

    The primary Out-* cmdlets included with PowerShell are:

    Command         Description
    -------         -----------
    Out-Default     Sends output to the default output paths, usually to the console in interactive sessions.
    Out-File        Sends output to a file.
    Out-Host        Bypasses the default output paths, sending output directly to the console host.
    Out-Null        Discards the output. Piping to Out-Null is similar to piping to /dev/null on Linux systems.
    Out-String      Sends output through the default display formatter and retrieves the pure string data.

    In most cases, there are more feature-complete cmdlets available for these tasks. However, it's important
    to be aware of how they behave as they are the underpinnings of PowerShell's communication with the system.
#>
Context 'Out-* Cmdlets' {

    Describe 'Out-Default' {

    }

    Describe 'Out-File' {

    }

    Describe 'Out-Host' {

    }

    Describe 'Out-Null' {

    }

    Describe 'Out-String' {

    }
}