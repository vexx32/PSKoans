function Get-PSKoanLocation {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Get-PSKoanLocation.md')]
    [OutputType([string])]
    param()
    process {
        if ($script:LibraryFolder) {
            $script:LibraryFolder
        }
        else {
            $ErrorDetails = @{
                Exception     = [System.IO.DirectoryNotFoundException]::new('PSKoans folder location has not been defined')
                ErrorId       = 'PSKoans.LibraryFolderNotDefined'
                ErrorCategory = 'NotSpecified'
                TargetObject  = $MyInvocation.MyCommand.Name
            }
            $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
        }
    }
}
