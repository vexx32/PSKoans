#Requires -Modules PSKoans

Describe 'Get-KoanCachedResult' {
    BeforeAll {
        Mock 'Get-FileHash' {
            [PSCustomObject]@{
                Hash   = 'abcdef'
            }
        }
    }

    It 'gets an entry when hashes match' {
        InModuleScope -ModuleName 'PSKoans' {
            $Script:KoanResultCache = @{
                'AboutAssertions.Koans' = @{
                    Hash   = 'abcdef'
                    Result = 'Result'
                }
            }

            Get-KoanCachedResult -Path 'AboutAssertions.Koans.ps1'
        } | Should -Be 'Result'
    }

    It 'returns nothing when hashes do not match' {
        InModuleScope -ModuleName 'PSKoans' {
            $Script:KoanResultCache = @{
                'AboutAssertions.Koans' = @{
                    Hash   = 'defabc'
                    Result = 'Result'
                }
            }

            Get-KoanCachedResult -Path 'AboutAssertions.Koans.ps1'
        } | Should -BeNullOrEmpty
    }

    It 'returns nothing when the item is not in the cache' {
        InModuleScope -ModuleName 'PSKoans' {
            $Script:KoanResultCache = @{}

            Get-KoanCachedResult -Path 'AboutAssertions.Koans.ps1'
        } | Should -BeNullOrEmpty
    }
}
