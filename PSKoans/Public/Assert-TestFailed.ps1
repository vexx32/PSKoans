using namespace System.Management.Automation

function Assert-TestFailed {
    <#
        .SYNOPSIS
        Assert-TestFailed unequivocally fails the parent `It` test.

        .DESCRIPTION
        This command is designed to mimic Pester's `Should` assertions, except it simply short-circuits to complete
        failure of the test at hand.

        .LINK
        about_Should
        about_Pester
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]
        $Message = 'The test failed'
    )
    begin { }
    process { }
    end {
        $exception = [Exception]::new($Message)
        $errorID = 'PesterAssertionFailed'
        $errorCategory = [ErrorCategory]::InvalidResult

        $targetObject = @{
            Message  = $Message
            File     = $MyInvocation.ScriptName
            Line     = $MyInvocation.ScriptLineNumber
            LineText = $MyInvocation.Line.TrimEnd("$([System.Environment]::NewLine)")
        }

        throw [ErrorRecord]::new($exception, $errorID, $errorCategory, $targetObject)
    }
}