#region Header
if (-not (Get-Module PSKoans)) {
    $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'
    Import-Module $moduleBase -Force
}
#endregion

InModuleScope 'PSKoans' {
    Describe "Show-Advice" {

        Context "Checking the Behaviour of  Function Calling" {
            
            Mock Write-ConsoleLine {} 
            $result  = Show-Advice

            It "Write-ConsoleLine With Paramter Title Should be Called " {
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter {$Title -eq $true}
            }

            It "Write-ConsoleLine Without Paramter Should be Called " {
               Assert-MockCalled -CommandName Write-ConsoleLine -Times 1
            }
            
            It "Show-Advice Output Should be Void"{
                $result | Should -BeNullOrEmpty
            }
        }

        Context "Checking the Behaviour of  Function Calling with parameter" {

            It "Write-ConsoleLine Without Paramter Should be Called " {
                Show-Advice -Name "Profile" | Should -BeNullOrEmpty
            }

        }

    }


    
}