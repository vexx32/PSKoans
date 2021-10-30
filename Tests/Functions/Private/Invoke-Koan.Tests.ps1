#Requires -Modules PSKoans

Describe 'Invoke-Koan' {

    BeforeAll {
        Mock Add-KoanCachedResult
        Mock Get-KoanCachedResult

        $testFile = @{ Script = "$PSScriptRoot/ControlTests/Invoke-Koan.Control_Tests.ps1" }
    }

    It 'runs the test successfully' {
        {
            InModuleScope 'PSKoans' -Parameters $testFile {
                param($Script)
                Invoke-Koan @{ Script = $Script }
            }
        } | Should -Not -Throw
    }

    It 'produces output with -Passthru' {
        InModuleScope 'PSKoans' -Parameters $testFile {
            param($Script)
            Invoke-Koan @{ Script = $Script; PassThru = $true }
        } | Should -Not -BeNullOrEmpty
    }

    It 'correctly reports test results' {
        $Results = InModuleScope 'PSKoans' -Parameters $testFile {
            param($Script)
            Invoke-Koan @{ Script = $Script; PassThru = $true }
        }

        $Results.TotalCount | Should -Be 2
        $Results.PassedCount | Should -Be 0
        $Results.FailedCount | Should -Be 2
    }

    It 'reports only expected exception types' {
        $Results = InModuleScope 'PSKoans' -Parameters $testFile {
            param($Script)
            Invoke-Koan @{ Script = $Script; PassThru = $true }
        }

        $Results.Tests.ErrorRecord.Exception |
            ForEach-Object -MemberName GetType |
            Should -Be @([Exception], [NotImplementedException])
    }

    Context 'item exists in cache' {
        BeforeAll {
            Mock Get-KoanCachedResult {
                'CachedResult'
            }
        }

        It 'returns a cached results if a cache entry exists' {
            InModuleScope 'PSKoans' -Parameters $testFile {
                param($Script)
                Invoke-Koan @{ Script = $Script; PassThru = $true }
            } | Should -Be 'CachedResult'

            Should -Invoke 'Get-KoanCachedResult'
            Should -Invoke 'Add-KoanCachedResult' -Times 0
        }
    }

    Context 'item does not exist in cache' {
        It 'adds an item to the cache when the pester run is successful' {
            InModuleScope 'PSKoans' -Parameters $testFile {
                param($Script)
                Invoke-Koan @{ Script = $Script; PassThru = $true }
            }

            Should -Invoke 'Get-KoanCachedResult'
            Should -Invoke 'Add-KoanCachedResult'
        }
    }
}
