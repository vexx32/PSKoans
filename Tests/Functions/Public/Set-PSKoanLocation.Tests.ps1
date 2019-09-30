#Requires -Modules PSKoans

Describe 'Set-PSKoanLocation' {
    BeforeAll {
        Mock Set-PSKoanSetting -ParameterFilter { $Name -eq 'KoanLocation' } -ModuleName PSKoans
    }

    It 'outputs no data by default' {
        Set-PSKoanLocation -Path 'TestDrive:/PSKoans' | Should -BeNullOrEmpty
    }

    It 'sets the KoanLocation setting' {
        Assert-MockCalled Set-PSKoanSetting -ModuleName PSKoans
    }

    It 'returns the input -Path value back to the pipeline with -PassThru' {
        $ResolvedPath = Resolve-Path -Path '~' | Join-Path -ChildPath 'PSKoans'
        Set-PSKoanLocation -Path '~/PSKoans' -PassThru | Should -BeExactly $ResolvedPath
    }
}
