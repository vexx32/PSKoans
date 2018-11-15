#Requires -Modules PSKoans

InModuleScope 'PSKoans' {
    Describe 'Write-MeditationPrompt' {
        BeforeAll {
            Mock Write-Host {}
            Mock Start-Sleep {}
        }

        Context 'Greeting Prompt' {

            It 'should only write a single string to host' {
                Write-MeditationPrompt -Greeting | Should -BeNullOrEmpty

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
                }
            }

            It 'should only display the complete prompt' {
                Write-MeditationPrompt @Meditation | Should -BeNullOrEmpty

                Assert-MockCalled Write-Host -Times 8
                Assert-MockCalled Start-Sleep -Times 3
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
                Write-MeditationPrompt @Meditation | Should -BeNullOrEmpty

                Assert-MockCalled Write-Host -Times 3
            }
        }
    }
}