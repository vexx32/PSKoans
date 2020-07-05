function Invoke-Koan {
    <#
    .SYNOPSIS
        Safely invokes Pester on a koan file in a fresh scope where tests can be executed out of harm's way.

    .DESCRIPTION
        Creates a new instance of PowerShell to execute the Pester tests in. Requires a valid parameter-splat hashtable
        for Invoke-Pester.

    .PARAMETER ParameterSplat
        Defines the hashtable that will be splatted into Invoke-Pester in the new PowerShell instance.

    .EXAMPLE
        Invoke-Koan @{ Script = '.\AboutArrays.Koans.ps1'; PassThru = $true; Show = 'None' }

        Triggers Pester to assess the AboutArrays file in the current directory and pass back the complete tests object,
        hiding the standard test results display.
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [Parameter(Position = 0, Mandatory)]
        [Alias('Params')]
        [hashtable]
        $ParameterSplat
    )
    end {
        try {
            $Requirements = [System.Management.Automation.Language.Parser]::ParseFile(
                $ParameterSplat.Script,
                [ref]$null,
                [ref]$null
            ).Ast.ScriptRequirements

            $Script = {
                param( $Params, $RequiredModules, $PSKoansPath, $PSModulePath )

                [System.Collections.Generic.HashSet[string]] $ModulePaths = @(
                    $PSModulePath -split [System.IO.Path]::PathSeparator
                    $env:PSModulePath -split [System.IO.Path]::PathSeparator
                )

                $env:PSModulePath = $ModulePaths -join [System.IO.Path]::PathSeparator

                Get-Module $PSKoansPath -ListAvailable | Import-Module
                foreach ($module in $RequiredModules) {
                    Import-Module $module
                }

                Invoke-Pester @Params
            }

            $Runspace = [powershell]::Create()
            $Runspace.AddScript($Script) > $null
            $Runspace.AddParameter('Params', $ParameterSplat) > $null
            $Runspace.AddParameter('PSKoansPath', $MyInvocation.MyCommand.Module.ModuleBase) > $null
            $Runspace.AddParameter('PSModulePath', $env:PSModulePath) > $null

            if ($Requirements.RequiredModules) {
                $Runspace.AddParameter('RequiredModules', $Requirements.RequiredModules)
            }

            $Status = $Runspace.BeginInvoke()

            do { Start-Sleep -Milliseconds 1 } until ($Status.IsCompleted)

            $Result = $Runspace.EndInvoke($Status)

            if ($Runspace.HadErrors) {
                # These will be errors outside the test itself; better propagate them upwards.
                foreach ($errorItem in $Runspace.Streams.Error) {
                    $PSCmdlet.WriteError($errorItem)
                }
            }

            $Result
        }
        finally {
            $Runspace.Dispose()
        }
    }
}
