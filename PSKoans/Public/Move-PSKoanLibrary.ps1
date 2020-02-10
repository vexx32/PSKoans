function Move-PSKoanLibrary {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Move-PSKoanLibrary.md')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('PSPath', 'Folder')]
        [string]
        $Path
    )
    process {
        if ($PSCmdlet.ShouldProcess($Path, 'Move existing koan files here')) {
            $OriginalPath = Get-PSKoanLocation

            Write-Verbose "Moving library files from '$OriginalPath' to '$Path'"
            Move-Item -Path $OriginalPath -Destination $Path -ErrorAction Stop

            Set-PSKoanLocation -Path $Path
        }
    }
}
