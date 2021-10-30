#Requires -Modules PSKoans

Describe 'Add-KoanCachedResult' {
    BeforeAll {
        Mock 'Get-FileHash' {
            [PSCustomObject]@{
                Hash = 'abcdef'
            }
        }
        Mock 'Export-CliXml'
    }

    It 'adds an entry to the cache when the entry does not exist' {
        InModuleScope -ModuleName 'PSKoans' {
            $Script:KoanResultCache = @{}

            Add-KoanCachedResult -Path 'AboutAssertions.Koans.ps1' -Result 'Result'
        }

        Should -Invoke 'Get-FileHash'
        Should -Invoke 'Export-CliXml'
    }

    It 'does nothing when the cache entry already exists and hashes match' {
        InModuleScope -ModuleName 'PSKoans' {
            $Script:KoanResultCache = @{
                'AboutAssertions.Koans' = @{
                    Hash = 'abcdef'
                }
            }

            Add-KoanCachedResult -Path 'AboutAssertions.Koans.ps1' -Result 'Result'
        }

        Should -Invoke 'Get-FileHash'
        Should -Invoke 'Export-CliXml' -Times 0
    }
}
