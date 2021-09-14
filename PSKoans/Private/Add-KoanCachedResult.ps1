function Add-KoanCachedResult {
    <#
    .SYNOPSIS
        Add an entry to the koan cache.

    .DESCRIPTION
        Cache the results of running tests for this koan. This avoids the overhead of repeatedly running pester on unchanged content.

    .PARAMETER Path
        The path to the koans test file.

    .PARAMETER PesterTests
        The result of running tests against the file created by the Invoke-Koan command.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [object]$Result
    )

    $currentHash = (Get-FileHash -Path $Path).Hash
    $cacheEntryName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

    if ($Script:KoanResultCache.Contains($cacheEntryName) -and $currentHash -eq $Script:KoanResultCache[$cacheEntryName]['Hash']) {
        # No work to do for this file. Return immediately.
        return
    }

    $cacheItemPath = Join-Path -Path $Script:CachePath -ChildPath (
        '{0}.xml' -f [System.IO.Path]::GetFileNameWithoutExtension($Path)
    )

    $cacheEntry = @{
        Hash   = $currentHash
        Result = $Result
    }
    $cacheEntry | Export-CliXml -Path $cacheItemPath -Depth 5

    $Script:KoanResultCache[$cacheEntryName] = $cacheEntry
}
