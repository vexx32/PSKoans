#Requires -Modules PSKoans

Describe 'Set-PSKoanLocation' {

    BeforeAll {
        Mock 'Set-PSKoanSetting' -ParameterFilter { $Name -eq 'KoanLocation' }
    }

    It 'outputs no data by default' {
        Set-PSKoanLocation -Path 'TestDrive:/PSKoans/' | Should -BeNullOrEmpty
    }

    It 'sets the KoanLocation setting' {
        Should -Invoke 'Set-PSKoanSetting' -Scope Describe
    }

    It 'returns the input -Path value back to the pipeline with -PassThru' {
        $ResolvedPath = Resolve-Path -Path '~' | Join-Path -ChildPath '/PSKoans/'
        Set-PSKoanLocation -Path '~/PSKoans/' -PassThru | Should -BeExactly $ResolvedPath
    }
}
