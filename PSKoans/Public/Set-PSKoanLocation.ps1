using namespace System.Management.Automation

class FolderTransformAttribute : ArgumentTransformationAttribute {
    [object] Transform([EngineIntrinsics]$engineIntrinsics, [object] $inputData) {
        switch ($inputData) {

            {$_ -is [string]} {

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

            {$_ -is [System.IO.FileSystemInfo]} {

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
    <#
    .SYNOPSIS
        Sets the PSKoans folder location where koans files will be stored and retrieved.

    .DESCRIPTION
        Sets the module-scoped PSKoanLocation variable in order to modify where the module looks for and
        stores its koans lesson files.

    .PARAMETER Path
        Specify the path to set the koan location to

    .EXAMPLE
        Set-PSKoanLocation -Path C:\PSKoans
        Measure-Karma

        Sets the koan folder location to 'C:\PSKoans' and then invokes Measure-Karma to examine that location
        for koans files.
    .NOTES
        The PSKoans folder specified will become the location to look for koans files. If this location
        is empty or nonexistent, it will be created and populated with a pristine copy of the koans library
        when Measure-Karma is run next.
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
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