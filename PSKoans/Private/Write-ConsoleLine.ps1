function Write-ConsoleLine {
    <#
    .SYNOPSIS
        Writes text to the console.
    .DESCRIPTION
        Cuts text to console-appropriate widths for viewing, where possible.
    .EXAMPLE
        PS C:\> Write-ConsoleLine $String

        Writes the contents of $String to the console, inserting new line characters
        where appropriate.
    .INPUTS
        Write-ConsoleLine accepts pipeline input for the $InputString parameter.
    .OUTPUTS
        Nothing. All output is sent only to the host / information stream.
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $InputString
    )
    begin {
        $Prefix = " " * 3
        $Width = $host.UI.RawUI.WindowSize.Width - ($Prefix.Length + 2)
    }
    process {
        # Ugly mode since width either not detectable or too small to bother
        if ($Width -lt 20) {
            Write-Host $InputString
        }
        else {
            $RemainingText = $InputString.TrimEnd()

            while ($RemainingText.Length -gt $Width) {
                $CompleteLine = $RemainingText.Substring(0, $Width)
                $TailFragment = ($CompleteLine -split "[- ]")[-1].Length
                $BestFitLine = $CompleteLine.Substring(0, $CompleteLine.Length - $TailFragment).TrimEnd()

                Write-Host ($Prefix + $BestFitLine)

                $RemainingText = $RemainingText.Substring($CompleteLine.Length - $TailFragment)
            }
            Write-Host ($Prefix + $RemainingText)
        }
    }
}