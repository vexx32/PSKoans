function Show-Advice {
    [CmdletBinding(HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Show-Advice.md')]
    [Alias('Get-Advice')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]
        $Name = "*"
    )
    begin {
        $AdviceFolder = $script:ModuleRoot | Join-Path -ChildPath 'Data/Advice'
    }
    process {
        $AdviceObject = Get-ChildItem -Path $AdviceFolder -Recurse -File -Filter "$Name.Advice.json" |
        Get-Random |
        Get-Content |
        ConvertFrom-Json

        # Checking for errors
        if (-not $AdviceObject) {
            $ErrorDetails = @{
                ExceptionType    = 'System.IO.FileNotFoundException'
                ExceptionMessage = 'Could not find any advices that match the specified Name'
                ErrorId          = 'PSKoans.NoMatchingAdvicesFound'
                ErrorCategory    = 'ObjectNotFound'
                TargetObject     = $Name
            }
            $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
        }
        elseif ($AdviceObject -and ((-not $AdviceObject.Title) -or ((-not $AdviceObject.Content)))) {
            $ErrorDetails = @{
                ExceptionType    = 'System.IO.FileLoadException'
                ExceptionMessage = 'Could not find title and/or content for specified Advice'
                ErrorId          = 'PSKoans.IncorrectAdviceData'
                ErrorCategory    = 'InvalidData'
                TargetObject     = $Name
            }
            $PSCmdlet.ThrowTerminatingError( (New-PSKoanErrorRecord @ErrorDetails) )
        }

        $AdviceObject.Title | Write-ConsoleLine -Title
        $AdviceObject.Content | Write-ConsoleLine
    }
    end {
    }
}
