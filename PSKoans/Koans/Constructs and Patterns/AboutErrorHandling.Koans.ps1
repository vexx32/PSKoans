using module PSKoans
[Koan(Position = 308)]
param()

<#
    Error Handling in PowerShell

    PowerShell handles errors via the System.Management.Automation.ErrorRecord class. These objects form
    the basic unit of "an error" in PowerShell.

    Errors can be flagged as terminating or non-terminating based on a few different criteria, largely
    determined by the command that creates the error. Terminating errors can be paired with try/catch
    patterns that
#>

Describe 'ErrorRecord' {

    It 'contains a reference to an Exception' {

    }

    It 'often has a reference to the object that caused the error' {

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
