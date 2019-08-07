function Reset-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Reset-PSKoan.md')]
    param(
        [Parameter(Mandatory)]
        [string]
        $Topic,

        [Parameter(Mandatory)]
        [String]
        $Name,

        [Parameter()]
        [String]
        $Context
    )

    $koanFilePath = Get-PSKoanFilePath -Topic $Topic
    $moduleKoan = Get-PSKoanIt -Path $koanFilePath.ModuleFilePath |
        Where-Object {
            $_.Name -like $Name -and
            (-not $Context -or $_.ID -like ('{0}\{1}' -f $Context, $Name))
        }

    if ($moduleKoan) {
        foreach ($koan in $moduleKoan) {
            $userKoan = Get-PSKoanIt -Path $koanFilePath.UserFilePath |
                Where-Object ID -eq $koan.ID

            if ($userKoan) {
                $content = Get-Content $koanFilePath.UserFilePath -Raw

                $content = $content.Remove(
                    $userKoan.Ast.Extent.StartOffset,
                    ($userKoan.Ast.Extent.EndOffset - $userKoan.Ast.Extent.StartOffset)
                ).Insert(
                    $userKoan.Ast.Extent.StartOffset,
                    $koan.Ast.Extent.Text
                )

                if ($pscmdlet.ShouldProcess(('Resetting "{0}" in {1}' -f $koan.Name, $Topic))) {
                    Set-Content -Path $koanFilePath.UserFilePath -Value $content
                }
            } else {
                Write-Error ('The koan "{0}" does not exist in the user path.' -f $koan.Name)
            }
        }
    } else {
        Write-Error ('The koan "{0}" does not exist.' -f $Name)
    }
}