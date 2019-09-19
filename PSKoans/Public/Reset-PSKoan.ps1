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

    $params = @{
        Scope = 'Module'
    }
    switch ($true) {
        { $Topic }         { $params['Topic'] = $Topic }
        { $Module }        { $params['Module'] = $Module }
        { $IncludeModule } { $params['IncludeModule'] = $IncludeModule }
    }
    Get-PSKoan @params | ForEach-Object {
        $moduleKoan = Get-KoanIt -Path $_.Path |
            Where-Object ID -like ('{0}/{1}' -f $Context, $Name)

        if ($moduleKoan) {
            $userKoanPath = Join-Path (Get-PSKoanLocation) -ChildPath $_.RelativePath

            if ($Name -ne '*' -or $Context -ne '*') {
                foreach ($koan in $moduleKoan) {
                    $userKoan = Get-KoanIt -Path $userKoanPath |
                        Where-Object ID -eq $koan.ID

                    if ($userKoan) {
                        $content = Get-Content -Path $userKoanPath -Raw

                        $content = $content.Remove(
                            $userKoan.Ast.Extent.StartOffset,
                            ($userKoan.Ast.Extent.EndOffset - $userKoan.Ast.Extent.StartOffset)
                        ).Insert(
                            $userKoan.Ast.Extent.StartOffset,
                            $moduleKoan.Ast.Extent.Text
                        )

                        if ($PSCmdlet.ShouldProcess($koan.Topic, ('Resetting "{0}"' -f $koan.Name))) {
                            Set-Content -Path $userKoanPath -Value $content.TrimEnd() -NoNewline
                        }
                    }
                    else {
                        $ErrorDetails = @{
                            ExceptionType    = 'System.Management.Automation.ItemNotFoundException'
                            ExceptionMessage = 'The koan "{0}" does not exist in the user path.' -f $koan.Name
                            ErrorId          = 'PSKoans.NoMatchingKoanItFound'
                            ErrorCategory    = 'ObjectNotFound'
                            TargetObject     = $koan
                        }
                        Write-Error -ErrorRecord (New-PSKoanErrorRecord @ErrorDetails)
                    }
                }
            }
            else {
                if ($PSCmdlet.ShouldProcess($_.Topic, "Resetting all koans")) {
                    Copy-Item -Path $_.Path -Destination $userKoanPath -Force
                }
            }
        }
        else {
            $message = 'The koan "{0}" does not exist in the topic {1}.' -f $Name, $_.Topic
            if ($Topic) {
                $ErrorDetails = @{
                    ExceptionType    = 'System.Management.Automation.ItemNotFoundException'
                    ExceptionMessage = $message
                    ErrorId          = 'PSKoans.NoMatchingKoanTopicFound'
                    ErrorCategory    = 'ObjectNotFound'
                    TargetObject     = $Topic -join ','
                }
                Write-Error -ErrorRecord (New-PSKoanErrorRecord @ErrorDetails)
            }
            else {
                Write-Verbose -Message $message
            }
        }
    }
}
