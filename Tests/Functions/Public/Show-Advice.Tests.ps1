#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe "Show-Advice" {

        Context "Behaviour of Parameter-less Calls" {
            
            Mock Write-ConsoleLine { } 
            $result = Show-Advice

            It "calls Write-ConsoleLine with Parameter -Title" {
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -eq $Title }
            }

            It "calls Write-ConsoleLine with only the display string" {
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -ne $Title } -Times 1
            }
            
            It "outputs nothing to the pipeline" {
                $result | Should -BeNullOrEmpty
            }
        }

        Context "Behaviour with -Name Parameter" {
            
            Mock Write-ConsoleLine { }

            It "should call Write-ConsoleLine with normal parameters" {
                Show-Advice -Name "Profile" 
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -ne $Title }
            }

            It "should call Write-ConsoleLine without parameters" {
                Show-Advice -Name "Profile.Advice" 
                Assert-MockCalled -CommandName Write-ConsoleLine -ParameterFilter { $null -eq $Title }
            }

            It "should throw an error if the requested file cannot be found" {
                $message = "Cannot validate argument on parameter 'InputString'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again."
                
                { Show-Advice -Name "ThisDoesntExist" -ErrorAction Stop } | Should -Throw -ExpectedMessage $message
            }
        }
    }   
}
