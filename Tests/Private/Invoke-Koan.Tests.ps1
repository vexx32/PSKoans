#Requires -Modules PSKoans

Describe 'Invoke-Koan' {

    BeforeAll {
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
}
