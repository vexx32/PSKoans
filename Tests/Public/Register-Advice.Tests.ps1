#Requires -Modules PSKoans

Describe "Register-Advice" {
    BeforeAll {
        $module = @{
            ModuleName = 'PSKoans'
        }
    }

    Context "Profile Folder/File Missing" {

        BeforeAll {
            Mock New-Item @module -Verifiable
            Mock Test-Path { $false } @module -Verifiable
            Mock Set-Content @module -Verifiable
        }

        It 'should create the $profile if it does not exist' {
            Register-Advice
            Should -InvokeVerifiable
        }
    }

    Context "Profile Already Exists" {

        BeforeAll {
            Mock Test-Path { $true } @module -Verifiable
            Mock Select-String { $false } @module -Verifiable
            Mock Add-Content @module -Verifiable
        }

        It "adds content to the profile if it already exists (Get|Set)-Advice" {
            Register-Advice
            Should -InvokeVerifiable
        }
    }

    Context "Parameter Validation" {

        BeforeAll {
            Mock Test-Path { $false } -ParameterFilter { $Path -eq $ProfileFolder } @module
            Mock New-Item @module
            Mock Test-Path { $false } -ParameterFilter { $Path -eq $ProfilePath } @module
            Mock Set-Content @module
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
