using module PSKoans
[Koan(Position = 308)]
param()

<#
    Error Handling in PowerShell

    PowerShell handles errors via the System.Management.Automation.ErrorRecord class. These objects form
    the basic unit of "an error" in PowerShell.

    Errors can be flagged as terminating or non-terminating based on a few different criteria, largely
    determined by the command that creates the error. Terminating errors can be paired with try/catch
    patterns that allow more granular control over exactly how the error is handled.
#>

Describe 'ErrorRecord' {
    BeforeAll {
        $Record = try {
            throw "A challenge to the sky!"
        }
        catch {
            $_
        }
    }

    It 'is an ErrorRecord' {
        # At times, even tautologies can make sense of what is, and is not.

        $Record -is [__] | Should -BeTrue
    }

    It 'always contains a reference to an Exception' {
        $Record.Exception | Should -Not -BeNullOrEmpty
        $Record.Exception -is [__] | Should -BeTrue
        "__" | Should -Be $Record.Exception.Message
    }

    It 'sometimes has a reference to the object that caused the error' {
        # But not always!
        $Record.TargetObject | Should -BeNullOrEmpty

        # Non-terminating error behaviour can be adjusted with the -ErrorAction parameter.
        Get-Item -Path "TestDrive:\This_Shouldn't_Exist" -ErrorAction SilentlyContinue

        <#
            $Error is an automatic variable that contains a list of recent errors. $Error[0] is the most recent.
            Even if an error is silenced with -ErrorAction SilentlyContinue, it is still recorded in $Error.

            If you want to completely hide the error, you'll need to use -ErrorAction Ignore instead.
        #>
        '__' | Should -Be $Error[0].TargetObject
    }

    It 'can be assigned one of the preset categories' {

    }

    It 'will usually specify an ErrorID' {

    }

    It 'may sometimes have additional details' {

    }

    It 'contains an InvocationInfo reference' {

    }

    It 'contains a stack trace for debugging' {

    }
}

Describe 'Types of Errors' {

    Context 'Non-Terminating Errors' {

        It 'is emitted with the Write-Error cmdlet' {

        }

        It 'can be customized in detail with the Write-Error cmdlet' {

        }

        It 'is created by WriteError()' {

        }
    }

    Context 'Terminating Errors' {

        It 'is created with the throw keyword' {

        }

        It 'is created by ThrowTerminatingError()' {

        }

        It 'can be created by the Write-Error cmdlet' {

        }
    }
}

Describe 'Proper Error Handling' {

    Context 'Deciding Between Terminating and Non-Terminating' {

    }
}
