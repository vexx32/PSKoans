$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'Tests', ''
$sut = "PSKoans.psm1"
Import-Module ($here | Join-Path -ChildPath $sut) -Prefix "TST"

Describe -Name "Initialize-KoanDirectory Unit Testing" -Fixture {
    Context -Name "Mocked Functions: Test-Path,Remove-Item, and Copy-Item" -Tag @("Mocking") -Fixture {
        Mock -CommandName Test-Path -MockWith { $false }
        Mock -CommandName Remove-Item -MockWith {}
        Mock -CommandName Copy-Item -MockWith {}

        Initialize-TSTKoanDirectory -Confirm:$false

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
        $KoanFolder = $Home | Join-Path -ChildPath 'PSKoans'
        If( Test-Path $KoanFolder){
            Remove-Item $KoanFolder -Recurse
        }
        Mock -CommandName Remove-Item -MockWith {}
        Mock -CommandName Copy-Item -MockWith {}

        Initialize-TSTKoanDirectory -Confirm:$false

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
    }#Context Mocked Functions
}#Describe Initalize-KoanDirectory

Describe -Name "Get-Enlightenment Unit Testing" -Fixture {
    Context -Name "Mocked Functions: Get-TSTEnlightenment -Reset" -Fixture{
        #Because the import-module above using a prefix
        #We have to import the module a second time to appropriately mock the internal functions.
        Import-Module "$here\$sut" -DisableNameChecking
        Mock -CommandName Initialize-KoanDirectory -MockWith {}
        Mock -CommandName Invoke-Item -MockWith {}
        Mock -CommandName Write-MeditationPrompt -MockWith {}
        Mock -CommandName Invoke-Pester -MockWith {}
        Mock -CommandName Clear-Host -MockWith {}

        Get-TSTEnlightenment -Reset

        It -name "Assert Initialize-KoanDirectory mocked in Reset switch" -test{
            Assert-MockCalled Initialize-KoanDirectory -Times 1
        }#It Initialize-KoanDirectory Mocked

        It -name "Assert other commands not executed in Reset switch" -test{
            Assert-MockCalled Invoke-Item -Times 0
            Assert-MockCalled Write-MeditationPrompt -Times 0
            Assert-MockCalled Invoke-Pester -Times 0
            Assert-MockCalled Clear-Host -Times 0
        }#It Invoke-Item Mocked
    }#Context Get-TSTEnlightenment -Reset
    Context -Name "Mocked Functions: Get-TSTEnlightenment -Meditate" -Fixture{
        #Because the import-module above using a prefix
        #We have to import the module a second time to appropriately mock the internal functions.
        Import-Module "$here\$sut" -DisableNameChecking
        Mock -CommandName Initialize-KoanDirectory -MockWith {}
        Mock -CommandName Invoke-Item -MockWith {}
        Mock -CommandName Write-MeditationPrompt -MockWith {}
        Mock -CommandName Invoke-Pester -MockWith {}
        Mock -CommandName Clear-Host -MockWith {}
        Get-TSTEnlightenment -Meditate
        It -name "Assert Invoke-Item Mocked in Meditate switch" -test{
            Assert-MockCalled Invoke-Item -Times 1
        }#It Invoke-Item Mocked
        It -name "Assert other commands not executed in Meditate switch" -test{
            Assert-MockCalled Initialize-KoanDirectory -Times 0
            Assert-MockCalled Write-MeditationPrompt -Times 0
            Assert-MockCalled Invoke-Pester -Times 0
            Assert-MockCalled Clear-Host -Times 0
        }#It Invoke-Item Mocked
    }#Context
    Context -Name "Mocked Functions: Get-TSTEnlightenment" -Fixture{
        #Because the import-module above using a prefix
        #We have to import the module a second time to appropriately mock the internal functions.
        Import-Module "$here\$sut" -DisableNameChecking
        Mock -CommandName Initialize-KoanDirectory -MockWith {}
        Mock -CommandName Invoke-Item -MockWith {}
        Mock -CommandName Write-MeditationPrompt -MockWith {}
        Mock -CommandName Invoke-Pester -MockWith {}
        Mock -CommandName Clear-Host -MockWith {}
        Get-TSTEnlightenment
        It -name "Assert Invoke-Item Mocked in Clear switch" -test{
            Assert-MockCalled Clear-Host -Times 1
            Assert-MockCalled Write-MeditationPrompt -Times 1
            Assert-MockCalled Invoke-Pester -Times 1
        }#It Invoke-Item Mocked
        It -name "Assert other commands not executed in Clear switch" -test{
            Assert-MockCalled Initialize-KoanDirectory -Times 0
            Assert-MockCalled Invoke-Item -Times 0
        }#It Invoke-Item Mocked

    }#Context Mocked Functions
}#Describe Get-Enlightenment

Remove-Module ($sut -replace ".psm1","")