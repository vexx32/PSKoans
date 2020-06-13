function Get-PSKoanLocation {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/main/docs/Get-PSKoanLocation.md')]
    [OutputType([string])]
    param()
    process {
        $Location = Get-PSKoanSetting -Name KoanLocation
        if ($Location) {
            $Location
        }
        else {
            $ErrorDetails = @{
                Exception     = [System.IO.DirectoryNotFoundException]::new(
                    'PSKoans folder location has not been defined'
                )
                ErrorId       = 'PSKoans.LibraryFolderNotDefined'
                ErrorCategory = 'NotSpecified'
                TargetObject  = $MyInvocation.MyCommand.Name
            }
            $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
        }
    }
}
