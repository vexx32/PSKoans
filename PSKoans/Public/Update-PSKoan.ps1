using namespace System.Collections.Generic

function Update-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "High",
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Update-PSKoan.md')]
    [OutputType([void])]
    param(
        [Parameter()]
        [Alias('Koan', 'File')]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                $Values = Get-PSKoanLocation | Get-ChildItem -Recurse -Filter '*.Koans.ps1' |
                Sort-Object -Property BaseName |
                ForEach-Object {
                    $_.BaseName -replace '\.Koans$'
                }

                return @($Values) -like "$WordToComplete*"
            }
        )]
        [string[]]
        $Topic
    )

    $KoanFolder = Get-PSKoanLocation
    if (-not (Test-Path -Path $KoanFolder)) {
        New-Item -Path $KoanFolder -ItemType Directory > $null
    }

    $ModuleKoanFolder = Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'
    $ModuleKoanList = Get-ChildItem -LiteralPath $ModuleKoanFolder -Recurse -Filter *.Koans.ps1 |
        Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -in $Topic } |
        Group-Object { $_.BaseName -replace '\.Koans$' } -AsHashTable -AsString

    $UserKoanList = Get-ChildItem -LiteralPath $KoanFolder -Recurse -Filter *.Koans.ps1 |
        Where-Object { -not $Topic -or $_.BaseName -replace '\.Koans$' -in $Topic } |
        Group-Object { $_.BaseName -replace '\.Koans$' } -AsHashTable -AsString

    if (-not $UserKoanList) {
        $UserKoanList = @{}
    }

    $TopicList = [HashSet[String]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($TopicName in [string[]]$ModuleKoanList.Keys + [string[]]$UserKoanList.Keys) {
        $null = $TopicList.Add($TopicName)
    }

    $ParentPathPattern = [regex]::Escape((Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'))

    switch ($TopicList) {
        { $ModuleKoanList.ContainsKey($_) } {
            $PathFragment = $ModuleKoanList[$_].Fullname -replace $ParentPathPattern
            $DestinationPath = Join-Path -Path $KoanFolder -ChildPath $PathFragment

            $ParentPath = Split-Path -Path $DestinationPath -Parent
            if (-not (Test-Path -Path $ParentPath)) {
                New-Item -Path $ParentPath -ItemType Directory > $null
            }
        }
        { $ModuleKoanList.ContainsKey($_) -and $UserKoanList.ContainsKey($_) } {
            if ($UserKoanList[$_].FullName -ne $DestinationPath) {
                if ($PSCmdlet.ShouldProcess($_, 'Moving Topic')) {
                    Write-Verbose "Moving $_"

                    $UserKoanList[$_] | Move-Item -Destination $DestinationPath
                }
            }

            Update-PSKoanFile -Topic $_

            continue
        }
        { $ModuleKoanList.ContainsKey($_) } {
            if ($PSCmdlet.ShouldProcess($_, 'Adding Topic')) {
                Write-Verbose "Adding $_"

                $ModuleKoanList[$_] | Copy-Item -Destination $DestinationPath -Force
            }

            continue
        }
        { $UserKoanList.ContainsKey($_) } {
            if ($PSCmdlet.ShouldProcess($_, 'Removing Topic')) {
                Write-Verbose "Removing $_"

                $UserKoanList[$_] | Remove-Item
            }

            continue
        }
    }
}
