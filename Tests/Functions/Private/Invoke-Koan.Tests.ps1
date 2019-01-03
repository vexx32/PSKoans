#Requires -Modules PSKoans

${global:Test File} = "$PSScriptRoot/ControlTests/Invoke-Koan.Control_Tests.ps1"

InModuleScope 'PSKoans' {
    Describe 'Invoke-Koan' {

        It 'will not error out' {
            {
                Invoke-Koan @{ Script = ${global:Test File} }
            } | Should -Not -Throw
        }

        It 'will produce output with -Passthru' {
            Invoke-Koan @{ Script = ${global:Test File} } -PassThru | Should -Not -BeNullOrEmpty
        }

        It 'will correctly report test results' {
            $Results = Invoke-Koan @{ Script = ${global:Test File } } -PassThru

            $Results.TotalCount | Should -Be 2
            $Results.PassedCount | Should -Be 0
            $Results.FailedCount | Should -Be 2
        }

        It 'reports only expected exception types' {
            $Results = Invoke-Koan @{ Script = ${global:Test File} } -PassThru

            $Results.TestResult.ErrorRecord.Exception |
                ForEach-Object -MemberName GetType |
                Should -Be @([Exception], [NotImplementedException])
        }
    }
}
