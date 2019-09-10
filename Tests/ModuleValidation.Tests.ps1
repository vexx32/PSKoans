$ProjectRoot = Resolve-Path "$PSScriptRoot/.."
$ModuleRoot = Split-Path (Resolve-Path "$ProjectRoot/*/*.psm1")
$ModuleName = Split-Path $ModuleRoot -Leaf

Describe "General project validation: $ModuleName" {
    $FileSearch = @{
        Path    = $ProjectRoot
        Include = '*.ps1', '*.psm1', '*.psd1'
        Recurse = $true
        Exclude = '*.Koans.ps1'
    }
    $Scripts = Get-ChildItem @FileSearch

    # TestCases are splatted to the script so we need hashtables
    $TestCases = $Scripts | ForEach-Object { @{File = $_} }
    It "<File> should be valid powershell" -TestCases $TestCases {
        param($File)

        $File.FullName | Should -Exist

        $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
        $Errors = $null
        [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
        $Errors.Count | Should -Be 0
    }

    It "<File> should include one (and only one) line feed at end of file" -TestCases $TestCases {
        param($File)
        $crlf = [Regex]::Match(($File | Get-Content -Raw), '(\r?(?<lf>\n))+\Z')
        $crlf.Groups['lf'].Captures.Count | Should -Be 1
    }

    It "'$ModuleName' can import cleanly" {
        {Import-Module (Join-Path $ModuleRoot "$ModuleName.psm1") -Force} | Should -Not -Throw
    }
}
