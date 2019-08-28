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
    if (-not (Test-Path $KoanFolder)) {
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

    foreach ($TopicName in $TopicList) {
        $ParentPathPattern = [regex]::Escape((Join-Path -Path $script:ModuleRoot -ChildPath 'Koans'))

        switch ($TopicName) {
            { $ModuleKoanList.ContainsKey($TopicName) } {
                $PathFragment = $ModuleKoanList[$TopicName].Fullname -replace $ParentPathPattern
                $DestinationPath = Join-Path -Path $KoanFolder -ChildPath $PathFragment

                $ParentPath = Split-Path -Path $DestinationPath -Parent
                if (-not (Test-Path -Path $ParentPath)) {
                    New-Item -Path $ParentPath -ItemType Directory > $null
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
