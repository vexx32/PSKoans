function Invoke-Koan {
    <#
        .FORWARDHELPTARGETNAME Invoke-Pester
        .FORWARDHELPCATEGORY Function
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Position = 0)]
        [Alias('Path', 'relative_path')]
        [PSObject[]]
        $Script,

        [Parameter(Position = 1)]
        [Alias('Name')]
        [string[]]
        $TestName,

        [Parameter(Position = 2)]
        [switch]
        $EnableExit,

        [Parameter(Position = 4)]
        [Alias('Tags')]
        [string[]]
        $Tag,

        [string[]]
        $ExcludeTag,

        [switch]
        $PassThru,

        [PSObject[]]
        $CodeCoverage,

        [string]
        $CodeCoverageOutputFile,

        [ValidateSet('JaCoCo')]
        [string]
        $CodeCoverageOutputFileFormat,

        [switch]
        $Strict,

        [Parameter(ParameterSetName = 'NewOutputSet', Mandatory = $true)]
        [string]
        $OutputFile,

        [Parameter(ParameterSetName = 'NewOutputSet')]
        [ValidateSet('NUnitXml')]
        [string]
        $OutputFormat,

        [switch]
        $Quiet,

        [PSObject]
        $PesterOption,

        [Pester.OutputTypes]
        $Show
    )
    end {
        try {
            $Script = {
                param($Params)

                . ([scriptblock]::Create('using module PSKoans'))
                Invoke-Pester @Params
            }

            $Thread = [powershell]::Create()
            $Thread.AddScript($Script) > $null
            $Thread.AddArgument($PSBoundParameters) > $null
            $Thread.RunspacePool = $RunspacePool

            $Status = $Thread.BeginInvoke()

            while (-not $Status.IsCompleted) { Start-Sleep -Milliseconds 10 }

            $Thread.EndInvoke($Status)
        }
        finally {
            $Thread.Dispose()
        }
    }
}
