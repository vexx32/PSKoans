using namespace System.Management.Automation
using module PSKoans

Describe 'Deliberately failing tests' {
    It 'simply fails' {
        Should -Fail -Because 'it is written that way'
    }

    It 'fails with a less clear error' {
        throw [NotImplementedException]::new('Test is invalid.')
    }
}