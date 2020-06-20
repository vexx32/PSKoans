using module PSKoans
[Koan(Position = 306)]
param()

<#
    Advanced Functions

    Advanced functions have a few extra rules when compared to simple functions:

        1. They must use [CmdletBinding()] as well as a param() block.
        2. All parameters must be explicitly declared; they cannot use $args to
           handle unbound arguments.

    They also have several optional features that you can take advantage of.
    Many of these can be used in tandem with one another, but to keep things
    manageable and clear here, we'll cover them one at a time.

    Typically functions are named in the same style as cmdlets, with Verb-Noun
    syntax for consistency and clarity. However, while this is an absolute
    requirement for cmdlets, functions can be named however you choose. Most
    functions you'll make use of in PowerShell probably fall into the category
    of "advanced functions."

    Unlike simple functions, which have to code their own logic for handling
    parameters, advanced functions need only supply a bit of metadata and let
    PowerShell do the rest. As a result, advanced functions tend to offer a more
    consistent and predictable experience than simple functions.

    In essence, advanced functions are a way of keeping tight control of the
    kinds of input that your function will be handling without needing to
    manually code a ton of logic for how parameters should world. This allows
    you to write rest of the code without worrying too much about how unexpected
    input might cause problematic results.
#>

Describe 'Advanced Functions' {

    BeforeAll {
        <#
            Before we get started, here's an example of an advanced function.
            We'll be using this as part of the tests, so while you're free to
            use it as reference, it's best not to tinker with it if you want the
            results to be accurate!

            If you do experiment with it and break something, you'll need to
            reset this file completely (which will undo any progress you've made
            in this file):

                Reset-PSKoan -Topic AboutAdvancedFunctions
        #>
        function Get-ParsedScript {
            # CmdletBinding attribute is declared before the param() block
            [CmdletBinding()]
            # OutputType is optional, but assists with tab completion.
            [OutputType([scriptblock])]
            param(
                <#
                    Parameters go inside the param() block and can have their
                    own attributes as well! This one has a Parameter attribute
                    which declares it as being Mandatory (the function cannot
                    run without it, and PowerShell will prompt for it if it's
                    missing) as well as ValueFromPipeline, which enables a
                    function to take pipeline input to that parameter.
                #>
                [Parameter(Mandatory, ValueFromPipeline)]
                [string]
                $Script
            )
            <#
                Both simple and advanced functions can utilize named function
                blocks. begin{} runs once for every time the function is called,
                while process{} can run once for every item provided as input
                over the pipeline, and then end{} will run just once after all
                the pipeline input has been processed.

                If input is provided only with parameters instead of using the
                pipeline, each block runs only once. The blocks can be written
                in any order, but it tends to be less confusing to write them
                in the order they'll be executing.

                Unused blocks can be left out completely if you prefer. You can
                opt to avoid named blocks completely, but all your code in a
                function will be executed in end{}, so pipeline input will be
                unavailable in this way.
            #>
            begin { }
            process {
                $errors = $null
                $parsedScript = [System.Management.Automation.Language.Parser]::ParseInput(
                    $Script, #      input  (string)
                    [ref]$null, #    tokens (Token[],      [ref] output)
                    [ref]$errors #  errors (ParseError[], [ref] output)
                )

                # Output is provided the same way as regular functions.
                [PSCustomObject]@{
                    ScriptBlock = $parsedScript
                    ParseErrors = $errors
                }
            }
            end { }
        }

        function Test-AdvancedFunction {
            [CmdletBinding()]
            [OutputType([bool])]
            param(
                [Parameter(Mandatory)]
                [scriptblock]
                $ScriptBlock
            )

            [bool]$ScriptBlock.Ast.FindAll(
                {
                    param($node)
                    $node -is [System.Management.Automation.Language.ParamBlockAst] -and
                    $node.Attributes[0].TypeName.Name -eq 'CmdletBinding'
                },
                $true
            )
        }
    }

    It 'must have a param() block and the CmdletBinding attribute' {
        # Add a param() below so that it is a valid advanced function.
        $myFunction = @'
        function Get-Number {
            [CmdletBinding()]
            ____

            process { 10 }
        }
'@

        $Result = Get-ParsedScript -Script $myFunction

        $Result.ParseErrors | Should -BeNullOrEmpty -Because 'the script should parse without errors'
        Test-AdvancedFunction $Result.ScriptBlock | Should -BeTrue -Because 'it should be an advanced function'

        <#
            We can load the function by dot-sourcing the resulting scriptblock.
            If you would like to experiment with it yourself, you can copy the
            script out of the here-string above into a console session directly.
        #>
        . $Result.ScriptBlock

        Get-Number | Should -Be 10
    }

    It 'will throw an error if undeclared parameters are provided' {

    }

    Context 'Parameter Attributes' {

        Describe 'The [Parameter()] Attribute' {

            It 'can use Parameter attributes for each parameter' {

            }

            It 'specifies whether a parameter accepts pipeline input' {

            }

            It 'specifies whether a parameter accepts pipeline input by property name' {

            }

            It 'specifies whether a parameter is Mandatory' {

            }

            It 'specifies parameter set membership for each parameter' {

            }

            It 'can be used once for each parameter set a parameter belongs to' {

            }
        }

        Describe 'Type Constraints' {

            It 'defines the acceptable input type for a parameter' {

            }

        }

        Describe 'Validation Attributes' {

            It 'rejects invalid values' {

            }

            It 'comes in several forms' {

            }

            It 'can be combined with other validation attributes' {

            }

            It 'is designed for use with specific types of parameters' {

            }
        }
    }

    Context 'Handling Pipeline Input' {

        It 'can be handled ByValue' {

        }

        It 'can be handled ByPropertyName' {

        }

        It 'can be handled with both forms of pipeline parameters' {

        }
    }


    Context 'The [CmdletBinding()] Attribute' {
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

        It 'provides the -WarningVariable common parameter' {

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
}
