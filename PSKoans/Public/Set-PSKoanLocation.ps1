using namespace System.Management.Automation

class FolderTransformAttribute : ArgumentTransformationAttribute {
    [object] Transform([EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        switch ($inputData) {

            { $_ -is [string] } {

                if (-not (Test-Path -Path $_ -PathType Container -IsValid)) {
                    throw [ArgumentTransformationMetadataException]::new('Path could not be resolved to a valid container.')
                }
                elseif (-not [string]::IsNullOrWhiteSpace($inputData)) {
                    try {
                        $FullPath = Resolve-Path -Path $InputData -ErrorAction Stop

                        if (-not [string]::IsNullOrWhiteSpace($FullPath)) {
                            return $FullPath.Path
                        }
                    }
                    catch [ItemNotFoundException] {
                        return $_.TargetObject
                    }
                }

            }

            { $_ -is [System.IO.FileSystemInfo] } {

                if (-not (Test-Path -Path $_.FullName -PathType Container)) {
                    throw [ArgumentTransformationMetadataException]::new('Path could not be resolved to a valid container.')
                }
                else {
                    return $inputData.Fullname
                }

            }
        }

        throw [System.IO.FileNotFoundException]::new()
    }
}

function Set-PSKoanLocation {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Set-PSKoanLocation.md')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('PSPath', 'Folder')]
        [FolderTransformAttribute()]
        [string]
        $Path
    )
    process {
        if ($PSCmdlet.ShouldProcess("Set PSKoans folder location to '$Path'")) {
            $script:LibraryFolder = $Path
            Write-Verbose "Set PSKoans folder location to $script:LibraryFolder"
        }
        else {
            Write-Warning "PSKoans folder location has not been changed."
        }
    }
}
