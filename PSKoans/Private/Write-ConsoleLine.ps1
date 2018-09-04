function Write-ConsoleLine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string]
        $InputString
    )

    $Width = $host.UI.RawUI.WindowSize.Width

    # Ugly mode since width either not detectable or too small to bother
    if ($Width -lt 20) {
        Write-Host "    $InputString"
    }
    else {
        $remainingLine = $InputString.TrimEnd()
        $lines = [System.Text.StringBuilder]::new()

        while ($remainingLine.Length -gt ($Width - 4))
        {
            $subString = $remainingLine.Substring(0, ($Width - 4))
            $end = ($subString -split " |-")[-1]
            $lines += $subString.Substring(0, ($subString.Length - $end.Length)).TrimEnd()
            $remainingLine = $remainingLine.Substring(($subString.Length - $end.Length))
        }
        $lines += $remainingLine

        foreach ($lineItem in $lines)
        {
            Write-Host "    $lineItem"
        }
    }
}