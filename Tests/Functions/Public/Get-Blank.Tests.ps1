#Requires -Modules PSKoans

Describe 'Get-Blank' {
    It 'should not produce output' {
        Get-Blank | Should -BeNullOrEmpty
    }
    
    It 'should be usable in the middle of a pipeline' {
        { Get-Variable | Get-Blank | Write-Output } | Should -Not -Throw
    }
    
    It 'should quietly ignore parameters' {
        { Get-Blank -Param1 Value1 -Param2 Value2 } | Should -Not -Throw
    }
}
