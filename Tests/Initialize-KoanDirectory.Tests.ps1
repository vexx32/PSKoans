$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', ''
$sut = "Private\Initialize-KoanDirectory.psm1"
Import-Module "$here\$sut" -Prefix "TST"

Describe -Name "Initialize-KoanDirectory Unit Testing" -Fixture {
    Context -Name "Mocked Functions: Test-Path,Remove-Item, and Copy-Item" -Tag @("Mocking") -Fixture {
        Mock -CommandName Test-Path -MockWith { $false }
        Mock -CommandName Remove-Item -MockWith {}
        Mock -CommandName Copy-Item -MockWith {}

        Initialize-TSTKoanDirectory -FirstImport

        It -name "Assert Test-Path mocked" -test {
            Assert-MockCalled -CommandName Test-Path -Times 1
        }#It
        It -name "Assert Remove-Item mocked" -test {
            Assert-MockCalled -CommandName Remove-Item -Times 0
        }#It
        It -name "Assert Copy-Item mocked" -test {
            Assert-MockCalled -CommandName Copy-Item -Times 1
        }#It
    }#Context Mocked Functions
    Context -Name "Mocked Functions: Remove-Item, and Copy-Item" -Tag @("Mocking") -Fixture {
        $KoanFolder = $env:TEMP | Join-Path -ChildPath 'PSKoans'
        If( Test-Path $KoanFolder){
            Remove-Item $KoanFolder -Recurse
        }
        Mock -CommandName Remove-Item -MockWith {}
        Mock -CommandName Copy-Item -MockWith {}

        Initialize-TSTKoanDirectory -Destination $KoanFolder

        It -name "Assert Remove-Item mocked" -test {
            Assert-MockCalled -CommandName Remove-Item -Times 0
        }#It
        It -name "Assert Copy-Item mocked" -test {
            Assert-MockCalled -CommandName Copy-Item -Times 1
        }#It
    }#Context Mocked Functions
    Context -Name "No mocking, live execution" -Fixture {
        $KoanFolder = $Home | Join-Path -ChildPath 'PSKoans'
        If( Test-Path $KoanFolder){
            Remove-Item $KoanFolder -Recurse
        }
        Initialize-TSTKoanDirectory -FirstImport

        It -name "KoanFolder Exists" -test {
            Test-Path $KoanFolder | Should -be $true
        }#It folder exists
        Remove-Item $KoanFolder -Recurse
    }#Context Mocked Functions
}#Describe Initalize-KoanDirectory

Remove-Module ($sut -replace ".psm1","")