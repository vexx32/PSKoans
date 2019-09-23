using namespace System.Collections.Generic

function Update-PSKoan {
    [CmdletBinding(
        SupportsShouldProcess,
        DefaultParameterSetName = 'TopicOnly',
        ConfirmImpact = "High",
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Update-PSKoan.md')]
    [OutputType([void])]
    param(
        [Parameter()]
        [Alias('Koan', 'File')]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter(Mandatory, ParameterSetName = 'ModuleOnly')]
        [SupportsWildcards()]
        [string[]]
        $Module,

        [Parameter(Mandatory, ParameterSetName = 'IncludeModule')]
        [SupportsWildcards()]
        [string[]]
        $IncludeModule
    )

    $KoanFolder = Get-PSKoanLocation
    if (-not (Test-Path -Path $KoanFolder)) {
        New-Item -Path $KoanFolder -ItemType Directory > $null
    }

    $GetParams = @{
        Scope                = 'Module'
        SkipAttributeParsing = $true
    }
    switch ($pscmdlet.ParameterSetName) {
        'IncludeModule' { $GetParams['IncludeModule'] = $IncludeModule }
        'ModuleOnly'    { $GetParams['Module'] = $Module }
        { $Topic }      { $GetParams['Topic'] = $Topic }
    }
    $ModuleKoanList = Get-PSKoan @GetParams | Group-Object Topic -AsHashtable -AsString

    $GetParams['Scope'] = 'User'
    $UserKoanList = Get-PSKoan @GetParams | Group-Object Topic -AsHashtable -AsString

    if (-not $UserKoanList) {
        $UserKoanList = @{ }
    }

    $TopicList = [HashSet[String]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($TopicName in [string[]]$ModuleKoanList.Keys + [string[]]$UserKoanList.Keys) {
        $null = $TopicList.Add($TopicName)
    }

    switch ($TopicList) {
        <#
            Create the parent folder if the topic is in the module list,
            and the parent directory does not yet exist in the users koan location.

            Update or Copy will follow.
        #>
        { $ModuleKoanList.ContainsKey($_) } {
            $DestinationPath = Join-Path -Path $KoanFolder -ChildPath $ModuleKoanList[$_].RelativePath

            $ParentPath = Split-Path -Path $DestinationPath -Parent
            if (-not (Test-Path -Path $ParentPath)) {
                New-Item -Path $ParentPath -ItemType Directory > $null
            }
        }
        <#
            Update

            If the topic is present in both the module and the users location: Attempt
            to update the existing koan topic by merging the users answers into the topic
            file copied from the module.
        #>
        { $ModuleKoanList.ContainsKey($_) -and $UserKoanList.ContainsKey($_) } {
            if ($UserKoanList[$_].Path -ne $DestinationPath) {
                if ($PSCmdlet.ShouldProcess($_, 'Moving Topic')) {
                    Write-Verbose "Moving $_"

                    $UserKoanList[$_].Path | Move-Item -Destination $DestinationPath
                }
            }

            Update-PSKoanFile -Topic $_

            continue
        }
        <#
            Copy

            If the topic only exists in the module location, copy the file to the users
            location.
        #>
        { $ModuleKoanList.ContainsKey($_) } {
            if ($PSCmdlet.ShouldProcess($_, 'Adding Topic')) {
                Write-Verbose "Adding $_"

                $ModuleKoanList[$_].Path | Copy-Item -Destination $DestinationPath -Force
            }

            continue
        }
        <#
            Remove

            If the topic only exists in the users location: Assume the topic has been retired
            or renamed and delete the file from the users koan location.
        #>
        { $UserKoanList.ContainsKey($_) } {
            if ($PSCmdlet.ShouldProcess($_, 'Removing Topic')) {
                Write-Verbose "Removing $_"

                $UserKoanList[$_].Path | Remove-Item
            }

            continue
        }
    }
}
