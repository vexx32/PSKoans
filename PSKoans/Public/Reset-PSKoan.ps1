function Reset-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Reset-PSKoan.md',
        PositionalBinding = $false,
        DefaultParameterSetName = 'NameOnly')]
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
        $IncludeModule,

        [Parameter()]
        [SupportsWildcards()]
        [string]
        $Name = '*',

        [Parameter()]
        [SupportsWildcards()]
        [string]
        $Context = '*'
    )

    $GetParams = @{
        Scope = 'Module'
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
        $UserKoanList = @{}
    }

    if (-not $ModuleKoanList) {
        $ErrorDetails = @{
            ExceptionType    = 'System.Management.Automation.ItemNotFoundException'
            ExceptionMessage = 'No koans found matching the specified Topic in the PSKoan module'
            ErrorId          = 'PSKoans.ModuleTopicNotFound'
            ErrorCategory    = 'ObjectNotFound'
            TargetObject     = $Topic
        }
        $pscmdlet.ThrowTerminatingError((New-PSKoanErrorRecord @ErrorDetails))
    }

    foreach ($moduleTopic in $ModuleKoanList.Keys) {
        if (-not $UserKoanList.ContainsKey($moduleTopic)) {
            $ErrorDetails = @{
                ExceptionType    = 'System.Management.Automation.ItemNotFoundException'
                ExceptionMessage = 'No matching topic {0} in the user Koan location' -f $moduleTopic
                ErrorId          = 'PSKoans.UserTopicNotFound'
                ErrorCategory    = 'ObjectNotFound'
                TargetObject     = $moduleTopic
            }
            Write-Error -ErrorRecord (New-PSKoanErrorRecord @ErrorDetails)

            continue
        }

        if ($Name -ne '*' -or $Context -ne '*') {
            $ModuleItCommands = Get-KoanIt -Path $ModuleKoanList[$moduleTopic].Path |
                Where-Object ID -like ('{0}/{1}' -f $Context, $Name) |
                Group-Object ID -AsHashTable -AsString

            if ($ModuleItCommands) {
                $UserItCommands = Get-KoanIt -Path $UserKoanList[$moduleTopic].Path |
                    Where-Object { $ModuleItCommands.Contains($_.ID) }

                if ($UserItCommands) {
                    $content = Get-Content -Path $UserKoanList[$moduleTopic].Path -Raw

                    $UserItCommands |
                        Sort-Object { $_.SourceAst.Extent.StartLineNumber } -Descending |
                        ForEach-Object {
                            # Replace the content of the koan with the modules content.
                            $content = $content.Remove(
                                $_.Ast.Extent.StartOffset,
                                ($_.Ast.Extent.EndOffset - $_.Ast.Extent.StartOffset)
                            ).Insert(
                                $_.Ast.Extent.StartOffset,
                                $ModuleItCommands[$_.ID].Ast.Extent.Text
                            )
                        }

                    if ($PSCmdlet.ShouldProcess($moduleTopic, 'Resetting selected Koans')) {
                        Set-Content -Path $UserKoanList[$moduleTopic].Path -Value $content.TrimEnd() -NoNewline
                    }
                }
                else {
                    $ErrorDetails = @{
                        ExceptionType    = 'System.Management.Automation.ItemNotFoundException'
                        ExceptionMessage = 'No matching koans in the topic {0} in the user Koan location' -f $moduleTopic
                        ErrorId          = 'PSKoans.UserItNotFound'
                        ErrorCategory    = 'ObjectNotFound'
                        TargetObject     = $moduleTopic
                    }
                    Write-Error -ErrorRecord (New-PSKoanErrorRecord @ErrorDetails)
                }
            }
            else {
                Write-Verbose -Message ('{0}: No matching koans in module' -f $moduleTopic)
            }
        }
        else {
            if ($PSCmdlet.ShouldProcess($moduleTopic, "Resetting all koans in topic")) {
                Copy-Item -Path $ModuleKoanList[$moduleTopic].Path -Destination $UserKoanList[$moduleTopic].Path -Force
            }
        }
    }
}
