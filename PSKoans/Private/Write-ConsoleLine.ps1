function Write-ConsoleLine {
    <#
    .SYNOPSIS
        Writes text to the console.
    .DESCRIPTION
        Cuts text to console-appropriate widths for viewing, where possible.
    .PARAMETER InputString
        The text to be displayed to the console.
    .PARAMETER Title
        Whether the text to display is the title.
    .NOTES
        Author: Joel Sallow (@vexx32)
    .EXAMPLE
        Write-ConsoleLine $String

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
        $InputString,

        [Parameter()]
        [switch]
        $Title
    )
    begin {
        Write-Host ""

        if ($Title) {
            Write-Host "Those who came before offer you a fragment of wisdom." -ForegroundColor Green
            Write-Host ""

            $Prefix = " " * 5
            $Color = @{ ForegroundColor = [ConsoleColor]::Yellow }
        }
        else {
            $Prefix = " " * 3
            $Color = @{ ForegroundColor = [ConsoleColor]::Gray }
        }

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

                Write-Host ($Prefix + $BestFitLine) @Color

                $RemainingText = $RemainingText.Substring($CompleteLine.Length - $TailFragment)
            }
            Write-Host ($Prefix + $RemainingText) @Color
        }
    }
    end {
        if (-not $Title) { Write-Host "" }
    }
}
