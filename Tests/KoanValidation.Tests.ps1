using module ..\PSKoans\PSKoans.psd1

$ProjectRoot = Resolve-Path "$PSScriptRoot/.."
$KoanFolder = $ProjectRoot | Join-Path -ChildPath 'PSKoans' | Join-Path -ChildPath 'Koans'

Describe "Koan Assessment" {
    BeforeAll {
        # TestCases are splatted to the script so we need hashtables
        $TestCases = InModuleScope PSKoans {
            Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.Koans.ps1' | ForEach-Object {
                $commandInfo = Get-Command -Name $_.FullName -ErrorAction SilentlyContinue
                $koanAttribute = $commandInfo.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }

                @{
                    File     = $_
                    Position = $koanAttribute.Position
                    Module   = $koanAttribute.Module
                }
            }
        }
    }

    It "<File> koans should be valid powershell" -TestCases $TestCases {
        param($File)

        $File.FullName | Should -Exist

        $Errors = $Tokens = $null
        [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$Tokens, [ref]$Errors) > $null
        $Errors.Count | Should -Be 0
    }

    It "<File> should include one (and only one) line feed at end of file" -TestCases $TestCases {
        param($File)

        $crlf = [Regex]::Match(($File | Get-Content -Raw), '(\r?(?<lf>\n))+\Z')
        $crlf.Groups['lf'].Captures.Count | Should -Be 1
    }

    It "<File> should have a Koan position" -TestCases $TestCases {
        param($File, $Position)

        $Position | Should -Not -BeNullOrEmpty
        $Position | Should -BeGreaterThan 0
    }

    It "Should not duplicate the Koan Position" {
        $DuplicatePosition = $TestCases |
            ForEach-Object { [PSCustomObject]$_ } |
            Group-Object { '{0}/{1}' -f $_.Module, $_.Position } |
            Where-Object Count -gt 1 |
            ForEach-Object { '{0}: {1}' -f $_.Name, ($_.Group.File -join ', ') }

        $DuplicatePosition | Should -BeNullOrEmpty
    }

    It "Should not have other PS1 files in the Koan directory" {
        Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.ps1' |
            Where-Object BaseName -notmatch '\.Koans$' |
            Should -BeNullOrEmpty
    }
}
