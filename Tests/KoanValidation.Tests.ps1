#Requires -Modules PSKoans

using namespace System.Management.Automation.Language
using namespace System.Collections.Generic

Describe 'Static Analysis: Koan Topics' {

    Context 'Individual Topics' {

        #region Discovery
        $KoanTopics = Resolve-Path "$PSScriptRoot/../PSKoans/Koans" |
            Get-ChildItem -Recurse -Filter '*.Koans.ps1' |
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
        #endregion Discovery

        It 'has no syntax errors in <Name>' -TestCases $KoanTopics {
            $File.FullName | Should -Exist

            $Errors = $Tokens = $null
            [Parser]::ParseFile($file.FullName, [ref]$Tokens, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }

        It 'does not have nested It blocks in <Name>' -TestCases $KoanTopics {
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

        It 'has exactly one line feed at end of the <Name> file' -TestCases $KoanTopics {
            $crlf = [Regex]::Match(($File | Get-Content -Raw), '(\r?(?<lf>\n))+\Z')
            $crlf.Groups['lf'].Captures.Count | Should -Be 1
        }

        It 'has a position number defined for <Name>' -TestCases $KoanTopics {
            param($File, $Position)

            $Position | Should -Not -BeNullOrEmpty
            $Position | Should -BeGreaterThan 0
        }
    }

    Context 'Library Cleanliness' {

        BeforeAll {
            $KoanFolder = Resolve-Path "$PSScriptRoot/../PSKoans/Koans"
        }

        It 'does not have topics with duplicate Koan positions' {
            $DuplicatePosition = Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.Koans.ps1' |
                ForEach-Object {
                    $commandInfo = Get-Command -name $_.FullName -ErrorAction SilentlyContinue
                    $koanAttribute = $commandInfo.ScriptBlock.Attributes.Where{ $_.TypeID -match 'Koan' }

                    [PSCustomObject]@{
                        File     = $_
                        Name     = $_.BaseName -replace '\.Koans$'
                        Position = $koanAttribute.Position
                        Module   = $koanAttribute.Module
                    }
                } |
                Group-Object { '{0}/{1}' -f $_.Module, $_.Position } |
                Where-Object Count -gt 1 |
                ForEach-Object { '{0}: {1}' -f $_.Name, ($_.Group.File -join ', ') }

            $DuplicatePosition | Should -BeNullOrEmpty
        }

        It 'does not have non-Koan Topic files in the Koans directory' {
            Get-ChildItem -Path $KoanFolder -Recurse -Filter '*.ps1' |
                Where-Object BaseName -notmatch '\.Koans$' |
                Should -BeNullOrEmpty
        }
    }
}
