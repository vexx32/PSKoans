#region Header
if (-not (Get-Module PSKoans)) {
   $moduleBase = Join-Path -Path $psscriptroot.Substring(0, $psscriptroot.IndexOf('\Tests')) -ChildPath 'PSKoans'

    Import-Module $moduleBase -Force
}
#endregion

InModuleScope 'PSKoans' {
    Describe 'Measure-Koan' {
        BeforeAll {
            Set-Content -Path TestDrive:\TestCases.Koans.ps1 -Value @'
                Describe 'Test cases param' {
                    It 'first <TestCase>' -TestCases @(
                        @{ TestCase = 1 }
                        @{ TestCase = 2 }
                        @{ TestCase = 3 }
                    ) {
                        param($TestCase)

                        $TestCase | Should -BeOfType int
                    }
                }
'@

                Set-Content -Path TestDrive:\JustIt.Koans.ps1 -Value @'
                    Describe 'Just it' {
                        It 'first' {
                            $true | Should -BeTrue
                        }

                        It 'second' {
                            $true | Should -BeTrue
                        }
                    }
'@

                Set-Content -Path TestDrive:\Mixed.Koans.ps1 -Value @'
                    Describe 'Mixed' {
                        It 'first' {
                            $true | Should -BeTrue
                        }

                        It 'second <TestCase>' -TestCases @(
                            @{ TestCase = 1 }
                            @{ TestCase = 2 }
                        ) {
                            param($TestCase)

                            $TestCase | Should -BeOfType int
                        }
                    }
'@

                Set-Content -Path TestDrive:\MutlipleTestCases.Koans.ps1 -Value @'
                    Describe 'Test cases param' {
                        It 'first <TestCase>' -TestCases @(
                            @{ TestCase = 1 }
                            @{ TestCase = 2 }
                            @{ TestCase = 3 }
                        ) {
                            param($TestCase)

                            $TestCase | Should -BeOfType int
                        }

                        It 'second <TestCase>' -TestCases @(
                            @{ TestCase = 1 }
                            @{ TestCase = 2 }
                            @{ TestCase = 3 }
                        ) {
                            param($TestCase)

                            $TestCase | Should -BeOfType int
                        }
                    }
'@
        }

        It 'counts the number of tests in <Path>' -TestCases @(
            @{ Path = 'TestDrive:\TestCases.Koans.ps1';         ExpectedValue = 3 }
            @{ Path = 'TestDrive:\JustIt.Koans.ps1';            ExpectedValue = 2 }
            @{ Path = 'TestDrive:\Mixed.Koans.ps1';             ExpectedValue = 3 }
            @{ Path = 'TestDrive:\MutlipleTestCases.Koans.ps1'; ExpectedValue = 6 }
        ) {
            param($Path, $ExpectedValue)

            $koanInfo = [PSCustomObject]@{
                Path       = $Path
                PSTypeName = 'PSKoans.KoanInfo'
            }

            $koanInfo | Measure-Koan | Should -Be $ExpectedValue
        }
    }
}
