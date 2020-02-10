function Set-PSKoanLocation {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Set-PSKoanLocation.md')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('PSPath', 'Folder')]
        [FolderTransformAttribute()]
        [string]
        $Path,

        [Parameter()]
        [switch]
        $PassThru
    )
    begin {
        $resolvedPath = $PSCmdlet.SessionState.Path.GetUnresolvedProviderPathFromPSPath($aPath)

        if ($resolvedPath.Count -gt 1 -or [WildcardPattern]::ContainsWildcardCharacters($resolvedPath)) {
            $ErrorDetails = @{
                ExceptionType    = [System.Management.Automation.PSArgumentException]
                ExceptionMessage = 'Wildcarded paths are not supported.'
                ErrorId          = 'InvalidPath'
                ErrorCategory    = 'InvalidArgument'
                TargetObject     = $Path
            }
            $PSCmdlet.ThrowTerminatingError((New-PSKoanErrorRecord @ErrorDetails))
        }
    }
    process {
        if ($PSCmdlet.ShouldProcess("Set PSKoans folder location to '$resolvedPath'")) {
            Set-PSKoanSetting -Name KoanLocation -Value $resolvedPath
        }
        else {
            Write-Warning "PSKoans folder location has not been changed."
        }

        if ($PassThru) {
            $resolvedPath
        }
    }
}
