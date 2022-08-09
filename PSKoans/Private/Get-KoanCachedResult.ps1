function Get-KoanCachedResult {
    <#
    .SYNOPSIS
        Add an entry to the koan cache.

    .DESCRIPTION
        Cache the results of running tests for this koan. This avoids the overhead of repeatedly running pester on unchanged content.

    .PARAMETER Path
        The path to the koans test file.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    $cacheEntryName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

    if ($Script:KoanResultCache.ContainsKey($cacheEntryName)) {
        $currentHash = (Get-FileHash -Path $Path).Hash
        $cacheEntry = $Script:KoanResultCache[$cacheEntryName]

        if ($currentHash -eq $cacheEntry['Hash']) {
            $cacheEntry['Result']
        }
    }
}
