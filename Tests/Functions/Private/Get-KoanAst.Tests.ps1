#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

InModuleScope PSKoans {
    Describe Get-KoanAst {
        BeforeAll {
            $path = Join-Path $TestDrive 'AboutSomething.Koans.ps1'

            Set-Content -Path $path -Value @'
                using module PSKoans
                [Koan(Position = 1)]
                param()
                <#
                    About Something
                #>
                Describe 'Something' {
                    It 'Has some examples' {
                        $true | Should -BeTrue
                    }
                }
'@
        }

        It 'Excludes the "using module PSKoans" statement from the AST'  {
            $ast = Get-KoanAst -Path $path

            $ast.UsingStatements | Should -BeNullOrEmpty
        }

        It 'When reading and modifying the source, position data is consistent' {
            $tokens = $errors = @()
            $originalAst = [System.Management.Automation.Language.Parser]::ParseFile(
                $path,
                [Ref]$tokens,
                [Ref]$errors
            )
            $originalItBlock = $originalAst.Find( {
                $args[0] -is [System.Management.Automation.Language.CommandAst] -and
                $args[0].GetCommandName() -eq 'It'
            }, $true)

            $modifiedAst = Get-KoanAst -Path $path
            $modifiedItBlock = $modifiedAst.Find( {
                $args[0] -is [System.Management.Automation.Language.CommandAst] -and
                $args[0].GetCommandName() -eq 'It'
            }, $true)

            $modifiedItBlock.Extent.StartOffset | Should -Be $originalItBlock.Extent.StartOffset
            $modifiedItBlock.Extent.EndOffset | Should -Be $originalItBlock.Extent.EndOffset
        }
    }
}
