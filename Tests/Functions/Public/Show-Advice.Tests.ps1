#Requires -Modules PSKoans

Describe "Show-Advice" {

    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
        Mock 'Write-ConsoleLine' @module
    }

    Context "Behaviour of Parameter-less Calls" {

        BeforeAll {
            $result = Show-Advice
        }

        It "calls Write-ConsoleLine with Parameter -Title" {
            Should -Invoke 'Write-ConsoleLine' @module -ParameterFilter { $null -eq $Title } -Scope Context
        }

        It "calls Write-ConsoleLine with only the display string" {
            Should -Invoke 'Write-ConsoleLine' @module -ParameterFilter { $null -ne $Title } -Scope Context
        }

        It "outputs nothing to the pipeline" {
            $result | Should -BeNullOrEmpty
        }
    }

    Context "Behaviour with -Name Parameter" {

        BeforeAll {
            Show-Advice -Name "Profile"
        }

        It "should call Write-ConsoleLine with normal parameters" {
            Should -Invoke 'Write-ConsoleLine' -ParameterFilter { $null -ne $Title } @module -Scope Context
        }

        It "should call Write-ConsoleLine without parameters" {
            Should -Invoke 'Write-ConsoleLine' -ParameterFilter { $null -eq $Title } @module -Scope Context
        }

        It "should throw an error if the requested file cannot be found" {
            $message = "Could not find any Advice files matching the specified Name: ThisDoesntExist."
            { Show-Advice -name "ThisDoesntExist" -ErrorAction Stop } | Should -Throw -ExpectedMessage $Message
        }
    }

    Context 'Behaviour with malformed advice files' {

        BeforeAll {
            $GetContentResult = [string]::Empty

            Mock Get-Content -MockWith { $GetContentResult } -Verifiable
            Mock Get-ChildItem -MockWith { [PSCustomObject]@{ PSPath = "DummyPath" } } -Verifiable
        }

        It "should throw an error if the requested file's format is not correct" -TestCases @(
            @{
                Json = @{
                    NotTitle   = "Fake title"
                    NotContent = @(1..4 | ForEach-Object { "Fake line $_" })
                } | ConvertTo-Json
            }
            @{
                Json = @{
                    Content = @(1..4 | ForEach-Object { "Fake line $_" })
                } | ConvertTo-Json
            }
            @{
                Json = @{
                    Title = "Fake title"
                } | ConvertTo-Json
            }
        ) {
            $GetContentResult = $Json
            $AdviceName = "TestAdvice"
            $Message = "Could not find Title and/or Content elements for Advice file: {0}" -f $AdviceName
            { Show-Advice -name $AdviceName -ErrorAction Stop } | Should -Throw -ExpectedMessage $Message
            Should -InvokeVerifiable
        }
    }
}
