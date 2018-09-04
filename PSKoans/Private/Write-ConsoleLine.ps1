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
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string]
        $InputString
    )
    $Prefix = " " * 3
    $Width = $host.UI.RawUI.WindowSize.Width - ($Prefix.Length + 2)

    # Ugly mode since width either not detectable or too small to bother
    if ($Width -lt 20) {
        Write-Host "    $InputString"
    }
    else {
        $RemainingText = $InputString.TrimEnd()

        while ($RemainingText.Length -gt $Width) {
            $CompleteLine = $RemainingText.Substring(0, $Width)
            $end = ($CompleteLine -split "[- ]")[-1]

            Write-Host ($Prefix + $CompleteLine.Substring(0, $CompleteLine.Length - $end.Length).TrimEnd())
            $RemainingText = $RemainingText.Substring($CompleteLine.Length - $end.Length)
        }
        Write-Host ($Prefix + $RemainingText)
    }
}