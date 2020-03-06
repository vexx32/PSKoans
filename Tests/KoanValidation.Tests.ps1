#Requires -Modules PSKoans

using namespace System.Management.Automation.Language
using namespace System.Collections.Generic

$ProjectRoot = Resolve-Path "$PSScriptRoot/.."
$KoanFolder = $ProjectRoot |
    Join-Path -ChildPath 'PSKoans' -AdditionalChildPath 'Koans'

Describe 'Koan Topics Static Analysis Checks' {

    Context 'Individual Topics' {

        BeforeAll {
            # TestCases are splatted to the script so we need hashtables
            $KoanTopics = Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.Koans.ps1' |
                ForEach-Object {
                    $commandInfo = Get-Command -Name $_.FullName -ErrorAction SilentlyContinue
                    $koanAttribute = $commandInfo.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }

                    @{
                        File     = $_
                        Name     = $_.BaseName -replace '\.Koans$'
                        Position = $koanAttribute.Position
                        Module   = $koanAttribute.Module
                    }
                }
        }

        It 'Koan Topic <Name> should be valid powershell' -TestCases $KoanTopics {
            param($File)

            $File.FullName | Should -Exist

            $Errors = $Tokens = $null
            [Parser]::ParseFile($file.FullName, [ref]$Tokens, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }

        It 'Koan Topic <Name> should not have nested It blocks' -TestCases $KoanTopics {
            param($File)

            function Test-ItBlock {
                [CmdletBinding()]
                param([Ast] $element)

                if ($element -isnot [CommandAst]) {
                    return $false
                }

                $commandName = $element.GetCommandName()
                if ([string]::IsNullOrEmpty($commandName)) {
                    return $false
                }

                if ($commandName -ne 'it') {
                    return $false
                }

                return $true
            }

            $Errors = $Tokens = $null
            $Ast = [Parser]::ParseFile($file.FullName, [ref]$Tokens, [ref]$Errors)
            $ParentItBlocks = [HashSet[Ast]]::new()

            $null = $Ast.FindAll(
                {
                    param([Ast] $currentAst)

                    if (-not (Test-ItBlock $currentAst)) {
                        return $false
                    }

                    for ($node = $currentAst.Parent; $null -ne $node; $node = $node.Parent) {
                        if (Test-ItBlock $node) {
                            return $ParentItBlocks.Add($node)
                        }
                    }

                    return $false
                },
                <# searchNestedScriptBlocks: #> $true
            )

            $ParentItBlocks | Should -BeNullOrEmpty -Because 'It blocks cannot be nested'
        }

        It 'Koan Topic <Name> should include one (and only one) line feed at end of file' -TestCases $KoanTopics {
            param($File)

            $crlf = [Regex]::Match(($File | Get-Content -Raw), '(\r?(?<lf>\n))+\Z')
            $crlf.Groups['lf'].Captures.Count | Should -Be 1
        }

        It 'Koan Topic <Name> should have a Koan position' -TestCases $KoanTopics {
            param($File, $Position)

            $Position | Should -Not -BeNullOrEmpty
            $Position | Should -BeGreaterThan 0
        }
    }

    Context 'Library Cleanliness' {

        It 'should not have topics with duplicate Koan positions' {
            $DuplicatePosition = $KoanTopics |
                ForEach-Object { [PSCustomObject]$_ } |
                Group-Object { '{0}/{1}' -f $_.Module, $_.Position } |
                Where-Object Count -gt 1 |
                ForEach-Object { '{0}: {1}' -f $_.Name, ($_.Group.File -join ', ') }

            $DuplicatePosition | Should -BeNullOrEmpty
        }

        It 'should not have non-Koan Topic files in the Koans directory' {
            Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.ps1' |
                Where-Object BaseName -notmatch '\.Koans$' |
                Should -BeNullOrEmpty
        }
    }
}
