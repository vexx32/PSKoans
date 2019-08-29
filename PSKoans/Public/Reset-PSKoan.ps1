function Reset-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Reset-PSKoan.md')]
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
        $Topic,

        [Parameter()]
        [string]
        $Name = '*',

        [Parameter()]
        [string]
        $Context
    )

    $params = @{}
    if ($Topic) {
        $params.Topic = $Topic
    }
    Get-PSKoanFile @params | ForEach-Object {
        $moduleKoan = Get-PSKoanIt -Path $_.ModuleFilePath |
            Where-Object {
                $_.Name -like $Name -and
                (-not $Context -or $_.ID -like ('{0}/{1}' -f $Context, $Name))
            }

        if ($moduleKoan) {
            foreach ($koan in $moduleKoan) {
                if ($Name -or $Context) {
                    $userKoan = Get-PSKoanIt -Path $_.UserFilePath |
                        Where-Object ID -eq $koan.ID

                    if ($userKoan) {
                        $content = Get-Content -Path $_.UserFilePath -Raw

                        $content = $content.Remove(
                            $userKoan.Ast.Extent.StartOffset,
                            ($userKoan.Ast.Extent.EndOffset - $userKoan.Ast.Extent.StartOffset)
                        ).Insert(
                            $userKoan.Ast.Extent.StartOffset,
                            $koan.Ast.Extent.Text
                        )

                        if ($PSCmdlet.ShouldProcess(('Resetting "{0}" in {1}' -f $koan.Name, $Topic))) {
                            Set-Content -Path $_.UserFilePath -Value $content
                        }
                    }
                    else {
                        Write-Error ('The koan "{0}" does not exist in the user path.' -f $koan.Name)
                    }
                }
                else {
                    if ($PSCmdlet.ShouldProcess($TopicName, "Resetting all koans in $TopicName")) {
                        Copy-Item -Path $_.ModuleFilePath -Destination $_.UserFilePath -Force
                    }
                }
            }
        }
        else {
            Write-Error ('The koan "{0}" does not exist.' -f $Name)
        }
    }
}
