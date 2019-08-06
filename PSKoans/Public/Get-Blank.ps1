function Get-Blank {
    <#
        .SYNOPSIS
        Get-Blank returns a blank object that represents no value, and is considered equal to
        no other object or value.
        
        .DESCRIPTION
        Get-Blank returns an object of type [Blank] as defined in the PSKoans module.
        This object is not equivalent to any other type of object, including itself, when compared
        with a standard `-eq` comparison.
        
        The only exception, which is unavoidable, is that it is considered equal to $true when
        $true is on the left-hand side of the comparison. Tthis kind of comparison may sometimes
        need to be carefully avoided when framing a koan assertion.
        
        For instance, the following assertion WILL pass, although it should not:
        
            ____ | Should -BeTrue
            
        .EXAMPLE
        __ | Should -Be (4 + 1)
        
        .EXAMPLE
        $Date = Get-Date
        $____ | Should -Be $Date
        
        .EXAMPLE
        $Num = Get-Random
        ____ | Should -Not -Be $num
    #>
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Get-Blank.md')]
    [OutputType('Blank')]
    [Alias('__', '____', 'FILL_ME_IN')]
    param(
        # Used to capture the input in a pipeline context, to avoid erroring out in those contexts.
        [Parameter(ValueFromPipeline, DontShow)]
        [object]
        ${|PipeInput},
        
        # Used to capture parameter names and arguments when used as a substitute for any other cmdlet.
        [Parameter(ValueFromRemainingArguments, DontShow)]
        [object[]]
        ${|ParameterInput}
    )

    Write-Verbose "I AIN'T DOIN' NOTHIN'!!!"

    return [Blank]::New()
}
