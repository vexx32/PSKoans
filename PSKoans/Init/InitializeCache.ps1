if (-not (Test-Path -Path $Script:CachePath)) {
    New-Item -Path $Script:CachePath -ItemType Directory > $null
}

$Script:KoanResultCache = @{}

foreach ($cacheItem in Get-ChildItem $Script:CachePath -Filter *.xml) {
    $Script:KoanResultCache[$cacheItem.BaseName] = Import-Clixml -Path $cacheItem.FullName
}
