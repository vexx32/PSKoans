function Update-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High",
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Update-PSKoan.md')]
    [OutputType([void])]
    param(
        [Parameter()]
        [string[]]
        $Topic
    )

    $KoanFolder = Get-PSKoanLocation

    $KoanPath = Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'
    $KoanList = Get-ChildItem -LiteralPath $KoanPath -Recurse -Filter *.Koans.ps1 |
        Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -in $Topic } |
        Group-Object { $_.BaseName -replace '\.Koans$' } -AsHashTable -AsString

    $UserKoanList = Get-ChildItem -LiteralPath $KoanFolder -Recurse -Filter *.Koans.ps1 |
        Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -in $Topic } |
        Group-Object { $_.BaseName -replace '\.Koans$' } -AsHashTable -AsString

    $TopicList = [System.Collections.Generic.HashSet[String]]::new([System.StringComparer]::InvariantCultureIgnoreCase)
    foreach ($TopicName in [String[]]$KoanList.Keys + [String[]]$UserKoanList.Keys) {
        $null = $TopicList.Add($TopicName)
    }

    foreach ($TopicName in $TopicList) {
        $ParentPathPattern = [regex]::Escape((Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'))

        switch ($TopicName) {
            { $KoanList.ContainsKey($TopicName) } {
                $PathFragment = $KoanList[$TopicName].Fullname -replace $ParentPathPattern
                $DestinationPath = Join-Path -Path $KoanFolder -ChildPath $PathFragment

                $ParentPath = Split-Path $DestinationPath -Parent
                if (-not (Test-Path $ParentPath)) {
                    $null = New-Item -Path $ParentPath -ItemType Directory
                }
            }
            { $KoanList.ContainsKey($TopicName) -and $UserKoanList.ContainsKey($TopicName) } {
                if ($UserKoanList[$TopicName].FullName -ne $DestinationPath) {
                    if ($PSCmdlet.ShouldProcess($TopicName, "Moving $TopicName")) {
                        Write-Verbose "Moving $TopicName"

                        $UserKoanList[$TopicName] | Move-Item -Destination $DestinationPath
                    }
                }

                Update-PSKoanFile -Topic $TopicName

                break
            }
            { $KoanList.ContainsKey($TopicName) } {
                if ($PSCmdlet.ShouldProcess($TopicName, "Adding $TopicName")) {
                    Write-Verbose "Adding $TopicName"

                    $KoanList[$TopicName] | Copy-Item -Destination $DestinationPath -Force
                }

                break
            }
            { $UserKoanList.ContainsKey($TopicName) } {
                if ($PSCmdlet.ShouldProcess($TopicName, "Removing $TopicName")) {
                    Write-Verbose "Removing $TopicName"

                    Remove-Item -LiteralPath $UserKoanList[$TopicName].PSPath
                }

                break
            }
        }
    }

    # Remove empty directories
    Get-ChildItem $KoanFolder -Directory -Recurse |
        Where-Object { -not (Get-ChildItem $_.FullName) } |
        Remove-Item
}