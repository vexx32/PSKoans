using module PSKoans
[Koan(Position = 306)]
param()

<#
    Advanced Functions

    A majority of functions you'll make use of in PowerShell fall into the broad
    category of "advanced functions." While simple functions are handy in a
    pinch, they can be quite fragile and afford neither protection nor automatic
    handling of any parameters like advanced functions allow you to create.

    Advanced functions have many pieces that make them work together, but in
    essence they are a way of keeping tight control of the kinds of input that
    your function will be handling. This allows you to write the code without
    worrying too much about how unexpected input might cause unexpected and
    problematic behaviour.
#>

Describe 'CmdletBinding' {
    <#
        [CmdletBinding()] is an attribute that can be applied to PowerShell
        functions. It has the effect of turning them into "advanced" functions.

        What this actually means is a bit complex, but in essence it brings them
        significantly closer to behaving like a true compiled cmdlet.

        When using CmdletBinding, parameters must be explicitly defined. There
        is no usage of $args, nor any ability to handle unbound parameters.
        Parameters that can't be bound by position or name will result in an
        error.
    #>

    Context 'Binding Parameters' {

        It 'does not strictly bind parameters for simple functions' {
            # Simple functions don't verify parameters passed to them.
            function Test-Function {
                param($Some)

                $args
            }

            $Results = Test-Function -Some "Values" -Passed 2 -TheFunction

            # Any undefined parameter names are assumed to be string arguments.
            $Values = @(
                '____'
                '-Passed'
                __
                '-____'
            )
            $Results | Should -BeExactly $Results
        }

        It 'strictly binds parameters for advanced functions' {
            function Test-Function {
                [CmdletBinding()]
                param($Some)

                $Some
                $args
            }

            $Message = '____'

            { Test-Function -Some Things -Are Strict } | Should -Throw -ExpectedMessage $Message
        }
    }
}

Describe 'Common Parameters' {
    <#
        When using CmdletBinding to create an advanced function, several
        automatic parameters are automatically given to the function:

            -Verbose
            -Debug
            -WarningAction
            -WarningVariable
            -ErrorAction
            -ErrorVariable
            -InformationAction
            -InformationVariable
            -OutVariable
            -OutBuffer
            -PipelineVariable
    #>

    It 'provides the -Verbose and -Debug common parameters' {
        <#
            -Verbose is a parameter that requests additional detail on a
            function's actions during processing. This information may be
            useful for debugging at times, but is also used as a basic kind
            of progress and additional metadata output.

            -Debug is very similar, but intended specifically for debug
            messages. In Windows PowerShell, -Debug mode will actually
            prompt before coninuing for every debug message emitted. This
            behaviour has changed in recent versions of PowerShell (6.2+)
            and it behaves more like a detailed and focused version of
            -Verbose.
        #>

        function Test-Verbose {
            [CmdletBinding()]
            param()

            <#
                A call to Write-Verbose displays the message, but only if
                -Verbose is enabled. It can be enabled with the -Verbose
                parameter, or by setting the $VerbosePreference variable to
                'Continue' or another mode that displays the result.

                By default, verbose messaging is NOT shown.
            #>
            Write-Verbose "____"
        }

        $String = "When you're falling in a forest, and there's nobody around, do you ever really crash or even make a sound?"

        <#
            By redirecting the verbose stream, we can test the result.
            Verbose is on stream 4, and debug is on stream 5.
        #>
        Test-Verbose 4>&1 | Should -BeNullOrEmpty

        # Verbose messages should appear with the -Verbose parameter.
        Test-Verbose -Verbose 4>&1 | Should -Be $String
    }

    It 'provides the -WarningAction common parameter' {
        function Test-WarningAction {
            [CmdletBinding()]
            param()

            <#
                Calling Write-Warning will generate a warning message.
                Warnings are visible by default.
            #>
            Write-Warning "____"
        }

        # Warnings are written to stream 3
        Test-WarningAction 3>&1 | Should -Be 'Something went wrong!'
        Test-WarningAction -WarningAction SilentlyContinue 3>&1 | Should -BeNullOrEmpty
    }

    It 'provides the stream-associated -*Variable common parameters' {
        <#
            With the -*Variable common parameters, individual streams can store
            their output into variables. Variables must be provided by name (as
            a string) to the corresponding parameter, and any existing content
            in the variable is overwritten. If you would like to append new
            stream output to existing content in the variable, you can specify a
            variable name prefixed with a plus sign (+).

            For the streams that display by default, this doesn't actively
            suppress any of their output; you need to combine them with a
            corresponding `-*Action` parameter if you want to suppress (or show,
            for streams that are hidden by default) the output of a given
            stream.

            Available -*Variable common parameters are:

            -WarningVariable
            -ErrorVariable
            -InformationVariable

            Note that Write-Host actually utilises the information stream, so
            the -InformationVariable will also capture any text sent to
            Write-Host. Out-Host instead bypasses all streams and writes
            directly to the host.
        #>

        function Test-StreamVariables {
            [CmdletBinding()]
            param()

            Write-Warning 'Warnings are shown by default'
            Write-Error 'Errors are also shown by default, usually with more detail'
            Write-Information 'Information is hidden by default, but still recorded by transcripts'
        }

        $Quiet = @{
            ErrorAction = 'SilentlyContinue'
            WarningAction = 'SilentlyContinue'
        }
        Test-StreamVariables @Quiet -InformationVariable 'info' -ErrorVariable 'err' -WarningVariable 'warn'

        # Which variables
        $____ | Should -Be 'Warnings are shown by default'
        $____ | Should -Be 'Errors are also shown by default, usually with more detail'
        $____ | Should -Be 'Information is hidden by default, but still recorded by transcripts'
    }

    It 'provides the -ErrorAction common parameter' {

    }

    It 'provides the -ErrorVariable common parameter' {

    }

    It 'provides the -InformationAction common parameter' {

    }

    It 'provides the -InformationVariable common parameter' {

    }

    It 'provides the -OutVariable common parameter' {

    }

    It 'provides the -OutBuffer common parameter' {

    }

    It 'provides the -PipelineVariable common parameter' {

    }
}
