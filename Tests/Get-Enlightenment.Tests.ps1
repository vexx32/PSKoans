$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
$sut = "Public\Get-Enlightenment.psm1"
Import-Module "$here\$sut" -Prefix "TST"
#sum -eq system under mock, to make it clear we are only interested in testing the Get-Enlightenment system
#sum is an array so we are easily able to add only modules to be mocked.
$sum = @("$here\Private\Initialize-KoanDirectory.psm1","$here\Private\Write-MeditationPrompt.psm1")

Describe -Name "Get-Enlightenment Unit Testing" -Fixture {
    BeforeAll {
        
        $SUModules = Import-Module $sum -PassThru -Global
        
        Mock -CommandName Initialize-KoanDirectory -MockWith {}
        Mock -CommandName Invoke-Item -MockWith {}
        Mock -CommandName Write-MeditationPrompt -MockWith {}
        Mock -CommandName Invoke-Pester -MockWith {}
        Mock -CommandName Clear-Host -MockWith {}
    }
    AfterAll{
        Remove-Module $SUModules
        Remove-Variable SUModules
        Remove-Variable sum
        Remove-Variable here
    }#AfterAll
    Context -Name "Mocked Functions: Get-TSTEnlightenment -Reset" -Fixture{
        

        Get-TSTEnlightenment -Reset -Confirm:$false -Destination ($env:TEMP | Join-Path -ChildPath "Koans")
        
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
    Context -Name "Mocked Functions: Get-Enlightenment -Meditate" -Fixture{

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