function Write-AdviceLine {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string]
        $Line
    )

    $width = $host.UI.RawUI.WindowSize.Width

    # Ugly mode since width either not detectable or too small to bother
    if ($width -lt 20) {
        Write-Host "    $Line"
    }
    else {
        $remainingLine = $Line.TrimEnd()
        $lines = [System.Text.StringBuilder]::new()

        while ($remainingLine.Length -gt ($width - 4))
        {
            $subString = $remainingLine.Substring(0, ($width - 4))
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