function Invoke-Koan {
    <#
        .FORWARDHELPTARGETNAME Invoke-Pester
        .FORWARDHELPCATEGORY Function
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
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
    begin {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Invoke-Pester', [System.Management.Automation.CommandTypes]::Function)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }

    process {
        try {
            $steppablePipeline.Process($_)
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }

    end {
        try {
            $steppablePipeline.End()
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}