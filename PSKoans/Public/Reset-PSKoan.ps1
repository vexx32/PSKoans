function Reset-PSKoan {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High',
        HelpUri = 'https://github.com/vexx32/PSKoans/tree/master/docs/Reset-PSKoan.md')]
    param(
        [Parameter(Mandatory)]
        [string]
        $Topic,

        [Parameter(Mandatory)]
        [String]
        $Name
    )

    $koanFilePath = Get-PSKoanFilePath -Topic $Topic
    $moduleKoan = Get-PSKoanIt -Path $koanFilePath.ModuleFilePath |
        Where-Object Name -like $Name

    if ($moduleKoan) {
        foreach ($koan in $moduleKoan) {
            $userKoan = Get-PSKoanIt -Path $koanFilePath.UserFilePath |
                Where-Object Name -eq $moduleKoan.Name

            if ($userKoan) {
                $content = Get-Content $koanFilePath.UserFilePath -Raw

                $content = $content.Remove(
                    $userKoan.Ast.Extent.StartOffset,
                    ($userKoan.Ast.Extent.EndOffset - $userKoan.Ast.Extent.StartOffset)
                ).Insert(
                    $userKoan.Ast.Extent.StartOffset,
                    $moduleKoan.Ast.Extent.Text
                )

                if ($pscmdlet.ShouldProcess(('Resetting "{0}" in {1}' -f $moduleKoan.Name, $Topic))) {
                    Set-Content -Path $koanFilePath.UserFilePath -Value $content
                }
            } else {
                Write-Error ('The koan "{0}" does not exist in the user path.' -f $moduleKoan.Name)
            }
        }
    } else {
        Write-Error ('The koan "{0}" does not exist.' -f $Name)
    }
}