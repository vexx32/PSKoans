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
            $result = Show-Advice

            It "calls Write-ConsoleLine with Parameter -Title" {
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter {$null -ne $Title}
            }

            It "Write-ConsoleLine Without Paramter Should be Called " {
               Assert-MockCalled -CommandName Write-ConsoleLine -Times 1
            }
            
            It "outputs nothing to the pipeline" {
                $result | Should -BeNullOrEmpty
            }
        }

        Context "Behaviour with -Name Parameter" {

            It "Write-ConsoleLine Without Paramter Should be Called " {
                Show-Advice -Name "Profile" | Should -BeNullOrEmpty
            }

        }

    }


    
}
