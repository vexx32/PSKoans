#Requires -Modules PSKoans

Describe 'Get-Blank' {

    It 'should not produce output' {
        $breakvar = $true;
        Get-Blank | Should -BeNullOrEmpty
    }
}
