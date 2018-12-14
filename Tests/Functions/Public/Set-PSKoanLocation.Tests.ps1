##Requires -Modules SKoans

Describe 'Set-PSKoanLocation' {

    Context 'Specified Folder Exists' {
        BeforeAll {
            $Location = 'TestDrive:{0}Test{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar
            New-Item -Path $Location -ItemType Directory > $null

            Set-PSKoanLocation -Path $Location
        }

        It 'should set the location correctly' {
            Get-PSKoanLocation | Should -Be $Location
        }

        It 'should set the module-scoped LibraryFolder variable' {
            InModuleScope 'PSKoans' { $script:LibraryFolder } | Should -Be $Location
        }

        AfterAll {
            Remove-Item -Path $Location
        }
    }

    Context 'Specified Folder Doesn''t Exist' {
        BeforeAll {
            $Location = 'TestDrive:{0}Test{0}PSKoans' -f [System.IO.Path]::DirectorySeparatorChar

            Set-PSKoanLocation -Path $Location
        }

        It 'should set the location correctly' {
            Get-PSKoanLocation | Should -Be $Location
        }

        It 'should set the module-scoped LibraryFolder variable' {
            InModuleScope 'PSKoans' { $script:LibraryFolder } | Should -Be $Location
        }
    }

    Context 'Specified Location is an Invalid Path' {

        It 'should throw an error' {
            $Location = 'TestDrive:::::\\\XD^^*#&'

            { Set-PSKoanLocation -Path $Location } | Should -Throw -ExpectedMessage 'Path could not be resolved to a valid container'
        }
    }
}