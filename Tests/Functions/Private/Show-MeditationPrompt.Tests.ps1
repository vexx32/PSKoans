#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Show-MeditationPrompt' {
        BeforeAll {
            Mock Write-Host { }
            Mock Start-Sleep { }
        }

        Context 'Greeting Prompt' {

            It 'should only write a single string to host' {
                Show-MeditationPrompt -Greeting | Should -BeNullOrEmpty

                Assert-MockCalled Write-Host -Times 1
            }
        }

        Context 'Standard Prompt' {
            BeforeAll {
                $Meditation = @{
                    DescribeName = "TestDescribe"
                    Expectation  = "TestExpectation"
                    ItName       = "TestIt"
                    Meditation   = "TestMeditation"
                    KoansPassed  = 0
                    TotalKoans   = 100
                    CurrentTopic = [PSCustomObject]@{
                        Name      = "TestTopic"
                        Completed = 0
                        Total     = 10
                    }
                }
            }

            It 'should only display the complete prompt' {
                Show-MeditationPrompt @Meditation | Should -BeNullOrEmpty

                Assert-MockCalled Write-Host -Times 8
            }
        }

        Context 'Enlightened Prompt' {
            BeforeAll {
                $Meditation = @{
                    Complete    = $true
                    KoansPassed = 100
                    TotalKoans  = 100
                }
            }

            It 'should display only the enlightened prompt' {
                Show-MeditationPrompt @Meditation | Should -BeNullOrEmpty

                Assert-MockCalled Write-Host -Times 3
            }
        }
    }
}
