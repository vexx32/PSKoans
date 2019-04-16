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
    <#
        All error types in PowerShell are accompanied by an ErrorRecord, which contains a lot of
        metadata that you can work with if you come across an error.
    #>
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
            $Error is an automatic variable that contains a list of recent errors. $Error[0] is always the most
            recent error. Even if an error is silenced with -ErrorAction SilentlyContinue, it is still recorded
            in $Error.

            If you want to completely hide the error, you need to use -ErrorAction Ignore instead.
        #>
        '__' | Should -Be $Error[0].TargetObject
    }

    It 'can be assigned one of the preset categories' {
        '__' -as [System.Management.Automation.ErrorCategory] | Should -Be $Record.CategoryInfo.Category
    }

    It 'will usually specify an ErrorID' {
        <#
            These ID strings are generally used to identify the source of the error and help distinguish
            between multiple similarly-typed errors.
        #>
        '__' | Should -Be $Record.FullyQualifiedErrorId
    }

    It 'contains an InvocationInfo reference' {
        # InvocationInfo is a quick snapshot of the surrounding environment when the error happened.
        __ | Should -Be $Record.InvocationInfo.ScriptLineNumber
        __ | Should -Be $Record.InvocationInfo.PipelineLength
        '+ __' | Should -Be $Record.InvocationInfo.PositionMessage
    }
}

Describe 'Types of Errors' {

    Context 'Non-Terminating Errors' {
        <#
            Non-terminating errors can be generated in one of two ways:
              - Using the Write-Error cmdlet.
              - Using the $PSCmdlet.WriteError() method in an advanced function.

            Non-terminating errors are an indication that a requested action could not be performed,
            or a resource that was specifically requested is not available.

            These errors will not terminate execution, allowing pipelines to carry on processing for
            all other input they may receive. Their behaviour can be modified by the -ErrorAction
            common parameter available on all cmdlets and advanced functions. The available values
            for the -ErrorAction parameter are:
              - Continue: As per normal, non-terminating errors are displayed and processing continues.
              - Ignore: Non-terminating errors are completely suppressed and not recorded in transcripts and $Error.
              - Inquire: Errors will pause execution and prompt the user for the desired action.
              - SilentlyContinue: Similar to Ignore, but errors are still recorded for later handling if needed.
              - Stop: Treat all errors as terminating errors.
        #>
        BeforeAll {
            function Write-SimpleError {
                Write-Error "Something went wrong!"
            }

            function Write-DetailedError {
                # These are only some of the parameters for Write-Error. Check Get-Help Write-Error -Full for more.
                $Params = @{
                    Exception         = [BadImageFormatException]::new("A broken mirror.")
                    Message           = "What happened here?"
                    ErrorId           = "PSKoans.TestError"
                    TargetObject      = @{Property = 1; Name = 'Jim' }
                    RecommendedAction = "Pass the test."
                }
                Write-Error @Params
            }

            function Write-ErrorWithMethod {
                [CmdletBinding()]
                param()

                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [Exception]::new("This is a very plain Exception."),
                    'PSKoans.TestWriteErrorMethod',
                    [System.Management.Automation.ErrorCategory]::LimitsExceeded,
                    { Secret-ScriptBlock }
                )

                $PSCmdlet.WriteError($ErrorRecord)
            }
        }

        It 'is emitted with the Write-Error cmdlet' {
            # The redirection operators can be used to more easily retrieve non-standard output, like errors
            $Error = Test-SimpleWriteError 2>&1

            '__' | Should -Be $Error.GetType().Name
        }

        It 'can be customized in detail with the Write-Error cmdlet' {
            $Record = Write-DetailedError 2>&1

            '__' | Should -Be $Record.Exception.Message
            '__.__' | Should -Be $Record.FullyQualifiedErrorId
            '__' | Should -Be $Record.TargetObject.Name
            '__' | Should -Be $Record.ErrorDetails.RecommendedAction
        }

        It 'is created by WriteError()' {
            $Record = Write-ErrorWithMethod 2>&1
            '__' | Should -Be $Record.FullyQualifiedErrorId
            '__' | Should -Be $Record.TargetObject.ToString()
        }
    }

    Context 'Terminating Errors' {
        <#
            Terminating errors are generated in a few ways:
              - The "throw" keyword.
              - The $PSCmdlet.ThrowTerminatingError() method.
              - Using -ErrorAction Stop on any cmdlet or advanced function that generates a non-terminating error.

            Note that -ErrorAction only affects errors which are created as non-terminating. Errors that are
            created as terminating cannot be guided via the -ErrorAction common parameter and will always be
            regarded as terminating.

            Terminating errors will terminate all further execution at the scope they occur in, and pass control
            back to the next scope up. The error will be propagated upwards until either it reaches the console
            and is displayed (at which point all currently-executing scripts will stop) or it triggers a "catch"
            block which will handle the error.

            The typical try/catch pattern looks like this:

                try {
                    # Code that might error.
                }
                catch [ExceptionType] {
                    # Code that handles error.
                    # In this block, $_ refers to the current ErrorRecord.
                }
                finally {

                }

            Note that specifying the exception type is optional. A "generic" catch block (no exception type
            specified) will simply catch everything. If you know the errors you're looking for, it's often
            best to only catch the ones you're expecting. If something else happens, you might make matters
            worse by handling that the same way as the errors you were expecting.

            A try{} block can be paired with either catch{}, finally{}, or both. In order words, all of the
            following are valid and useful code patterns, depending on the circumstances.
                - try { ~code~ } catch { ~code~ }
                - try { ~code~ } finally { ~code~ }
                - try { ~code~ } catch { ~code~ } finally { ~code~ }

            The finally{} block will always run whether or not the commands in the try or catch blocks generate an error of any kind, so it is often useful for disposing of objects and other cleanup when it is needed.
        #>

        It 'can be created with the throw keyword' {
            try {
                throw "A red ball."
            }
            catch {
                # A red ball is thrown... and what is caught?
                $_ -is [__] | Should -BeTrue
                $_.Exception -is [__] | Should -BeTrue
                '__' | Should -Be $_.Exception.Message
            }
        }

        It 'can be created by ThrowTerminatingError()' {
            # ThrowTerminatingError() can only be called from within an advanced function.
            function Invoke-TerminatingError {
                [CmldetBinding()]
                param()

                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.Management.Automation.WildcardPatternException]::new("The pattern breaks."),
                    'PSKoans.TestTerminatingError',
                    [System.Management.Automation.ErrorCategory]::DeadlockDetected,
                    @{ Secret = 'Blue' }
                )

                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }

            try {
                Invoke-TerminatingError
            }
            catch {
                # What can we catch here?
                $_ -is [__] | Should -BeTrue
                $_.Exception -is [__] | Should -BeTrue
                '__' | Should -Be $_.Exception.Message
                '__' | Should -Be $_.TargetObject.Secret
            }
        }

        It 'can be created by the Write-Error cmdlet' {
            try {
                # Provided, of course, we apply -ErrorAction Stop.
                $Params = @{
                    Message      = 'The writing upon the walls...'
                    Category     = 'InvalidData'
                    ErrorId      = 'PSKoans.Invalid'
                    TargetObject = @('Chalk', 'Crayon', 'Marker', 'Pen', 'Pencil')
                    ErrorAction  = 'Stop'
                }
                Write-Error @Params
            }
            catch {
                $_ -is [__] | Should -BeTrue
                [__] | Should -Be $_.Exception.GetType()
                '__' | Should -Be $_.Exception.Message
                @('__', '__', '__') | Should -Be $_.TargetObject[3..1]
            }
        }
    }

    <#
        Selecting Error Types

        In general terms:
        - Use the throw keyword when you intend to catch the error in the same function or script for further
        handling, or you're writing a script to perform a series of tasks and you need to exit immediately
        when the error occurs.
        - Use the $PSCmdlet.ThrowTerminatingError(), $PSCmdlet.WriteError(), or their Write-Error equivalents
        when you intend for the error to be handled by whoever is running the command you're writing.
    #>
}
