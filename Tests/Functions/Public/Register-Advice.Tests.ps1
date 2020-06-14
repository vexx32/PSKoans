#Requires -Modules PSKoans

Describe "Register-Advice" {

    Context "Profile Folder/File Missing" {

        BeforeAll {
            Mock New-Item -Verifiable
            Mock Test-Path { $false } -Verifiable
            Mock Set-Content -ParameterFilter { $Value -eq "Show-Advice" } -Verifiable
        }

        It 'should create the $profile if it does not exist' {
            Register-Advice
            Should -InvokeVerifiable
        }
    }

    Context "Profile Already Exists" {

        BeforeAll {
            Mock 'Test-Path' { $true } -Verifiable
            Mock 'Select-String' { $false } -Verifiable
            Mock 'Add-Content' -Verifiable
        }

        It "adds content to the profile if it already exists (Get|Set)-Advice" {
            Register-Advice
            Should -InvokeVerifiable
        }
    }

    Context "Parameter Validation" {

        BeforeAll {
            Mock Test-Path { $false } -ParameterFilter { $Path -eq $ProfileFolder }
            Mock New-Item
            Mock Test-Path { $false } -ParameterFilter { $Path -eq $ProfilePath }
            Mock Set-Content -ParameterFilter { $Value -eq "Show-Advice" }
        }

        It "throws if an invalid value is supplied for -TargetProfile" {
            { Register-Advice -TargetProfile "Invalidvalue" } | Should -Throw
        }

        It "works correctly with the <ProfilePath> profile" -TestCases @(
            @{ ProfilePath = 'AllUsersAllHosts' }
            @{ ProfilePath = 'AllUsersCurrentHost' }
            @{ ProfilePath = 'CurrentUserAllHosts' }
            @{ ProfilePath = 'CurrentUserCurrentHost' }
        ) {
            try {
                Register-Advice $ProfilePath | Should -BeNullOrEmpty
            }
            catch [UnauthorizedAccessException] {
                # Current user doesn't have access to the profile path. This can be normal for the 'AllUsers' paths.
                if ($ProfilePath -notmatch '^AllUsers') {
                    throw $_
                }
            }
        }
    }
}
