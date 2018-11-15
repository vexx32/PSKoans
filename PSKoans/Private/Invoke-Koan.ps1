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
    end {
        $GlobalScope = [psmoduleinfo]::new($true)

        & $GlobalScope {
            param($Params)

            Invoke-Pester @Params
        } @($PSBoundParameters)

    }
}