#Requires -Modules PSKoans

Describe 'Get-KoanAst' {

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

    It 'excludes the "using module PSKoans" statement from the AST' {
        $ast = InModuleScope 'PSKoans' -Parameters @{ Path = $path } {
            param($Path)
            Get-KoanAst -Path $Path
        }

        $ast.UsingStatements | Should -BeNullOrEmpty
    }

    It 'maintains consistency of position data when reading and modifying the source' {
        $tokens = $errors = $null
        $originalAst = [System.Management.Automation.Language.Parser]::ParseFile(
            $path,
            [Ref]$tokens,
            [Ref]$errors
        )

        $originalItBlock = $originalAst.Find(
            {
                $args[0] -is [System.Management.Automation.Language.CommandAst] -and
                $args[0].GetCommandName() -eq 'It'
            },
            $true
        )

        $modifiedAst = InModuleScope 'PSKoans' -Parameters @{ Path = $path } {
            param($Path)
            Get-KoanAst -Path $Path
        }

        $modifiedItBlock = $modifiedAst.Find(
            {
                $args[0] -is [System.Management.Automation.Language.CommandAst] -and
                $args[0].GetCommandName() -eq 'It'
            },
            $true
        )

        $modifiedItBlock.Extent.StartOffset |
            Should -Be $originalItBlock.Extent.StartOffset -Because 'the start offsets should match'
        $modifiedItBlock.Extent.EndOffset |
            Should -Be $originalItBlock.Extent.EndOffset -Because 'the end offsets should match'
    }
}
