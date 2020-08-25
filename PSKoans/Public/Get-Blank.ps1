function Get-Blank {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/main/docs/Get-Blank.md')]
    [OutputType('Blank')]
    [Alias('__', '____', 'FILL_ME_IN')]
    param(
        [Parameter(ValueFromPipeline, DontShow)]
        [object]
        ${|PipeInput},

        [Parameter(ValueFromRemainingArguments, DontShow)]
        [object[]]
        ${|ParameterInput}
    )

    Write-Verbose "I AIN'T DOIN' NOTHIN'!!!"

    return [Blank]::New()
}
