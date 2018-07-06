Get-ChildItem -Path "$PSScriptRoot\Koans" -Filter '*.Tests.ps1' |
    ForEach-Object {
        $KoansFailed = Invoke-Pester -Script $_.FullName
        if (-not $KoansFailed) {
            break
        }
    }