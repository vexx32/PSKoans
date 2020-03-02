#Requires -Modules PSKoans

Describe 'Move-PSKoanLibrary' {

    Context 'Unit Tests with Mocks' {

        BeforeAll {
            $OriginalPath = New-Item -Path 'TestDrive:/PSKoans' -ItemType Directory |
                Select-Object -ExpandProperty FullName
            $TestPath = New-Item -ItemType Directory -Path 'TestDrive:/TestPath' | Join-Path -ChildPath 'Koans'

            Mock Get-PSKoanLocation { $OriginalPath }.GetNewClosure() -ModuleName PSKoans
            Mock Set-PSKoanLocation -ParameterFilter { $Path -eq $TestPath } -ModuleName PSKoans
            Mock Move-Item -ParameterFilter { $Path -eq $OriginalPath } -MockWith { $Destination }  -ModuleName PSKoans
        }

        It 'should output the new location' {
            Move-PSKoanLibrary -Path $TestPath | Should -BeExactly $TestPath
        }

        It 'should call Get-PSKoanLocation' {
            Assert-MockCalled Get-PSKoanLocation -ModuleName PSKoans
        }

        It 'should call Move-Item' {
            Assert-MockCalled Move-Item -ModuleName PSKoans
        }

        It 'should call Set-PSKoanLocation' {
            Assert-MockCalled Set-PSKoanLocation -ModuleName PSKoans
        }
    }

    Context 'Integration Tests' {

        BeforeAll {
            $OldLocation = Get-PSKoanLocation

            Set-PSKoanLocation -Path 'TestDrive:/PSKoans'
            Update-PSKoan -Confirm:$false

            $OriginalFileHashes = Get-PSKoanLocation |
                Get-ChildItem -Recurse -File |
                Get-FileHash |
                ForEach-Object {
                    @{
                        File = ($_.Path -split [regex]::Escape([IO.Path]::DirectorySeparatorChar))[-2, -1] -join ':'
                        Hash = $_.Hash
                    }
                }

            $NewLocation = 'TestDrive:/NewLocation/PSKoans'
            New-Item -Path ($NewLocation | Split-Path -Parent) -ItemType Directory
        }

        AfterAll {
            Set-PSKoanLocation $OldLocation
        }

        It 'should move the folder to the new location' {
            Move-PSKoanLibrary -Path $NewLocation
            Test-Path $NewLocation -PathType Container | Should -BeTrue
        }

        It 'should update the KoanLocation' {
            Get-PSKoanLocation | Should -BeExactly (Get-Item -Path $NewLocation).FullName
        }

        It 'should copy <File> to the new location' -TestCases $OriginalFileHashes {
            param($File, $Hash)

            $FileName = ($File -split ':')[-1]

            $NewHash = Get-ChildItem -Path $NewLocation -Recurse -File -Filter "*$FileName*" |
                Get-FileHash |
                Select-Object -ExpandProperty Hash

            $NewHash | Should -BeExactly $Hash
        }
    }

}
