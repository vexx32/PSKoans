using module PSKoans
[Koan(Position = 401)]
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
        <#
            Sooner or later, Out-Default will receive all output that passes through the pipeline.
            We can capture this data as it is received, for example to create a $LastOutput variable.

                $PSDefaultParameterValues['Out-Default:OutVariable'] = 'LastOutput'

            You can experiment with this in your own console, and even define your very own Out-Default
            function. However, be very careful doing so! If you don't at some point write the output
            to the host from Out-Default, you'll break your console display!

            When overriding Out-Default, you should always follow this scaffold to avoid breaking
            something:

                function Out-Default {
                    [CmdletBinding()]
                    param(
                        [Parameter(ValueFromPipeline)]
                        [PSObject]
                        $InputObject,

                        [switch]
                        $Transcript
                    )
                    begin {
                        $Data = [System.Collections.ArrayList]::new()

                        # Additional code / logic here
                    }
                    process {
                        $Data.Add($InputObject) > $null

                        # Additional code / logic here
                    }
                    end {
                        # Additional code / logic here

                        $Data | Microsoft.PowerShell.Core\Out-Default -Transcript:($Transcript)
                    }
                }

            The reason for the extra code is that you want the original Out-Default function to
            still receive all the input that it would normally have gotten (in most cases);
            if it does not, and you don't handle it yourself with Out-Host or something
            along those lines, you can and will break your console.
        #>
    }

    Describe 'Out-File' {
        <#
            Out-File behaves similarly to Set/Add-Content. It is generally not used too often,
            partially because in older versions of PowerShell it has a different default
            encoding than those cmdlets, frequently confusing users.
        #>

        It 'stores data in files' {
            $Path = 'TestDrive:\File.txt'

            'Stored knowledge is of little value until it is used.' | Out-File -FilePath $Path -NoNewline

            '____' | Should -Be (Get-Content -Path $Path)
        }
    }

    Describe 'Out-Host' {
        <#
            Out-Host is very similar to Write-Host, although it lacks the color functionality.

            The one major difference is that Out-Host does not create InformationRecord objects
            like Write-Host does. Because of this, it cannot be suppressed, silenced, or
            redirected. For this reason it is typically not recommended for common use.

            However, its host output is still recorded on transcripts.
        #>
    }

    Describe 'Out-Null' {
        # Out-Null discards any input sent to it, making it very useful for suppressing output.

        It 'does absolutely nothing with output sent to it' {
            $String = '____'
            $String | Should -Be 'What can you learn to do today that you have never ben able to do before?'

            $String | Out-Null | Should -BeNullOrEmpty
        }
    }

    Describe 'Out-String' {
        <#
            Out-String is a fantastic and simple way to turn complex objects into strings that look just
            like PowerShell's default console formatting.
        #>

        It 'creates string representations of data' {
            #Create a hashtable that pipes into Out-String
            $ExpectedString = @{ ____ = '____'; Spectrum = '____' } | Out-String

            $ActualString = @"

Name                           Value
----                           -----
Color                          Blue
Spectrum                       Ultraviolet



"@ # Mind the indentations; here-strings have to terminate at the very beginning of a line.
            $ActualString | Should -Be $ExpectedString
        }
    }
}
