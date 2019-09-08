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
            $Script = {
                param( $Params )

                . ([scriptblock]::Create('using module PSKoans'))
                Invoke-Pester @Params
            }

            $Thread = [powershell]::Create()
            $Thread.AddScript($Script) > $null
            $Thread.AddArgument($ParameterSplat) > $null

            $Status = $Thread.BeginInvoke()

            do { Start-Sleep -Milliseconds 1 } until ($Status.IsCompleted)

            $Thread.EndInvoke($Status)
        }
        finally {
            $Thread.Dispose()
        }
    }
}
