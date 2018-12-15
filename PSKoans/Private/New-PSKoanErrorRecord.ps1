using namespace System.Management.Automation

function New-PSKoanErrorRecord {
    <#
    .SYNOPSIS
        Constructs an error record for other functions to throw.

    .DESCRIPTION
        Creates an error record using the given parameters and outputs it as an object. This error record can later be
    thrown by other functions.

    .PARAMETER ExceptionType
        The type name or [type] object representing a specific [Exception]. Only types that inherit [Exception] in some
        way can be used.

    .PARAMETER ExceptionMessage
        The message to store in the Exception object of the ErrorRecord.

    .PARAMETER Exception
        A complete [Exception] object already constructed can be passed directly to this parameter.

    .PARAMETER ErrorId
        A unique string identifying this ErrorRecord.

    .PARAMETER ErrorCategory
        The standard category name or value for this ErrorRecord.

    .PARAMETER TargetObject
        The object or command which raised the exception, or caused the exception to be raised.

    .EXAMPLE
        $ErrorDetails = @{
            ExceptionType    = 'System.IO.FileNotFoundException'
            ExceptionMessage = 'Could not find any koans that match the specified Topic(s)'
            ErrorId          = 'PSKoans.NoMatchingKoansFound'
            ErrorCategory	 = 'ObjectNotFound'
            TargetObject	 = $Topic -join ','
        }
        $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )

        Constructs an error record out of disparate parts and throws it to terminate the current command.
    #>

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([ErrorRecord])]
    param(
        [Parameter(ParameterSetName = 'Default')]
        [Alias('Type')]
        [ValidateScript(
            {
                if (-not $_ -as [Type] -is [Exception]) {
                    throw [ArgumentException]::new( 'The entered type name is not a valid exception type' )
                }
                else {
                    $true
                }
            }
        )]
        [Type]
        $ExceptionType = [Exception],

        [Parameter(ParameterSetName = 'Default')]
        [Alias('Message')]
        [string]
        $ExceptionMessage,

        [Parameter(Mandatory, ParameterSetName = 'ExceptionObject')]
        [Exception]
        $Exception,

        [Parameter()]
        [Alias('Id')]
        [string]
        $ErrorId = 'PSKoans.GenericError',

        [Parameter()]
        [Alias('Category')]
        [ErrorCategory]
        $ErrorCategory = [ErrorCategory]::NotSpecified,

        [Parameter()]
        [PSObject]
        $TargetObject
    )
    process {
        if ($PSCmdlet.ParameterSetName -eq 'Default') {
            $Exception = $ExceptionType::new( $ExceptionMessage )
        }

        [ErrorRecord]::new(
            $Exception,
            $ErrorId,
            $ErrorCategory,
            $TargetObject
        )
    }
}