function Reset-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Reset-PSKoan.md',
        PositionalBinding = $false,
        DefaultParameterSetName = 'NameOnly')]
    [OutputType([void])]
    param(
        [Parameter()]
        [Alias('Koan', 'File')]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)

                $Values = (Get-PSKoanFile).Topic
                return @($Values) -like "$WordToComplete*"
            }
        )]
        [SupportsWildcards()]
        [string[]]
        $Topic,

        [Parameter()]
        [SupportsWildcards()]
        [string]
        $Name = '*',

        [Parameter(Mandatory, ParameterSetName = 'NameAndContext')]
        [SupportsWildcards()]
        [string]
        $Context
    )

    $params = @{ }
    if ($Topic) {
        $params.Topic = $Topic
    }
    Get-PSKoanFile @params | ForEach-Object {
        $moduleKoan = Get-PSKoanIt -Path $_.ModuleFile.FullName |
            Where-Object {
                $_.Name -like $Name -and
                ($pscmdlet.ParameterSetName -eq 'NameOnly' -or $_.ID -like ('{0}/{1}' -f $Context, $Name))
            }

        if ($moduleKoan) {
            foreach ($koan in $moduleKoan) {
                if ($Name -or $Context) {
                    $userKoan = Get-PSKoanIt -Path $_.UserFile.FullName |
                        Where-Object ID -eq $koan.ID

                    if ($userKoan) {
                        $content = Get-Content -Path $_.UserFile.FullName -Raw

                        $content = $content.Remove(
                            $userKoan.Ast.Extent.StartOffset,
                            ($userKoan.Ast.Extent.EndOffset - $userKoan.Ast.Extent.StartOffset)
                        ).Insert(
                            $userKoan.Ast.Extent.StartOffset,
                            $koan.Ast.Extent.Text
                        )

                        if ($PSCmdlet.ShouldProcess(('Resetting "{0}" in {1}' -f $koan.Name, $_.Topic))) {
                            Set-Content -Path $_.UserFile.FullName -Value $content -NoNewline
                        }
                    }
                    else {
                        Write-Error ('The koan "{0}" does not exist in the user path.' -f $koan.Name)
                    }
                }
                else {
                    if ($PSCmdlet.ShouldProcess($_.Topic, "Resetting all koans")) {
                        Copy-Item -Path $_.ModuleFile.FullName -Destination $_.UserFile.FullName -Force
                    }
                }
            }
        }
        else {
            $message = 'The koan "{0}" does not exist in the topic {1}.' -f $Name, $_.Topic
            if ($Topic) {
                $ErrorDetails = @{
                    ExceptionType    = 'System.Management.Automation.ItemNotFoundException'
                    ExceptionMessage = $message
                    ErrorId          = 'PSKoans.NoMatchingKoanFound'
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
