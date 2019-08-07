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

    $ModuleKoanFolder = Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'
    $ModuleKoanList = Get-ChildItem -LiteralPath $ModuleKoanFolder -Recurse -Filter *.Koans.ps1 |
        Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -in $Topic } |
        Group-Object { $_.BaseName -replace '\.Koans$' } -AsHashTable -AsString

    $UserKoanList = Get-ChildItem -LiteralPath $KoanFolder -Recurse -Filter *.Koans.ps1 |
        Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -in $Topic } |
        Group-Object { $_.BaseName -replace '\.Koans$' } -AsHashTable -AsString

    $TopicList = [HashSet[String]]::new(
        [System.StringComparer]::InvariantCultureIgnoreCase)
    foreach ($TopicName in [String[]]$ModuleKoanList.Keys + [String[]]$UserKoanList.Keys) {
        $null = $TopicList.Add($TopicName)
    }

    foreach ($TopicName in $TopicList) {
        $ParentPathPattern = [regex]::Escape((Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'))

        switch ($TopicName) {
            { $ModuleKoanList.ContainsKey($TopicName) } {
                $PathFragment = $ModuleKoanList[$TopicName].Fullname -replace $ParentPathPattern
                $DestinationPath = Join-Path -Path $KoanFolder -ChildPath $PathFragment

                $ParentPath = Split-Path -Path $DestinationPath -Parent
                if (-not (Test-Path -Path $ParentPath)) {
                    $null = New-Item -Path $ParentPath -ItemType Directory
                }
            }
            { $ModuleKoanList.ContainsKey($TopicName) -and $UserKoanList.ContainsKey($TopicName) } {
                if ($UserKoanList[$TopicName].FullName -ne $DestinationPath) {
                    if ($PSCmdlet.ShouldProcess($TopicName, "Moving $TopicName")) {
                        Write-Verbose "Moving $TopicName"

                        $UserKoanList[$TopicName] | Move-Item -Destination $DestinationPath
                    }
                }

                Update-PSKoanFile -Topic $TopicName

                break
            }
            { $ModuleKoanList.ContainsKey($TopicName) } {
                if ($PSCmdlet.ShouldProcess($TopicName, "Adding $TopicName")) {
                    Write-Verbose "Adding $TopicName"

                    $ModuleKoanList[$TopicName] | Copy-Item -Destination $DestinationPath -Force
                }

                break
            }
            { $UserKoanList.ContainsKey($TopicName) } {
                if ($PSCmdlet.ShouldProcess($TopicName, "Removing $TopicName")) {
                    Write-Verbose "Removing $TopicName"

                    $UserKoanList[$TopicName] | Remove-Item
                }

                break
            }
        }
    }
}
