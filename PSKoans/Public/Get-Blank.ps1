function Get-Blank {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Get-Blank.md')]
    [OutputType('Blank')]
    [Alias('__', '____', 'FILL_ME_IN')]
    param()

    Write-Verbose "I AIN'T DOIN' NOTHIN'!!!"

    return [Blank]::New()
}
