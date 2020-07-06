Describe 'Static Analysis: Module & Repository Files' {

    #region Discovery
    $FileSearch = @{
        Path    = Resolve-Path "$PSScriptRoot/.."
        Include = '*.ps1', '*.psm1', '*.psd1'
        Recurse = $true
        Exclude = '*.Koans.ps1'
    }
    $Scripts = Get-ChildItem @FileSearch

    $TestCases = $Scripts | ForEach-Object { @{ File = $_ } }
    #endregion Discovery

    Context 'Repository Code' {

        It 'has no invalid syntax errors in <File>' -TestCases $TestCases {
            $File.FullName | Should -Exist

            $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
            $Errors = $null
            [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }

        It 'has exactly one line feed at EOF in <File>' -TestCases $TestCases {
            $crlf = [Regex]::Match(($File | Get-Content -Raw), '(\r?(?<lf>\n))+\Z')
            $crlf.Groups['lf'].Captures.Count | Should -Be 1
        }
    }

    Context 'Module Import' {

        BeforeAll {
            $ModuleName = 'PSKoans'
            $ModuleRoot = (Get-Module -Name $ModuleName).ModuleBase
        }

        It 'cleanly imports the module' {
            { Import-Module (Join-Path $ModuleRoot "$ModuleName.psm1") -Force } | Should -Not -Throw
        }

        It 'removes and re-imports the module without errors' {
            $Script = {
                Remove-Module $ModuleName
                Import-Module (Join-Path -Path $ModuleRoot -ChildPath "$ModuleName.psm1")
            }

            $Script | Should -Not -Throw
        }
    }
}
