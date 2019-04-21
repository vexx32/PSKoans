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
        $AdviceObject = Get-ChildItem -Path $AdviceFolder -Recurse -File -Filter "$Name.json" |
        Get-Random |
        Get-Content |
        ConvertFrom-Json

        $AdviceObject.Title | Write-ConsoleLine -Title
        $AdviceObject.Content | Write-ConsoleLine
    }
    end {
    }
}
