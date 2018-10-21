using module PSKoans
[Koan(Position = 206)]
param()
<#
    Select-Object

    Select-Object is a utility cmdlet that is used to 'trim' objects down to just
    the selected properties. It is particularly useful to get custom displays
    of data, and is capable of adding new properties as well.
#>
Describe 'Select-Object' {

    It 'selects specific properties of an object' {
        $File = New-TemporaryFile
        "Hello" | Set-Content -Path $File.FullName
        $File = Get-Item -Path $File.FullName

        $Selected = $File | Select-Object -Property Name, Length
        $Selected.PSObject.Properties.Name | Should -Be @('Name', '__')

        $Selected.Length | Should -Be __
    }

    It 'can exclude specific properties from an object' {
        $File = New-TemporaryFile

        $File.Attributes | Should -Be '__'

        $Object = $File | Select-Object -Property * -ExcludeProperty Attributes, Length

        $Object.Attributes | Should -Be $null
        $Object.Length | Should -Be __
    }

    It 'changes the object type' {
        $FileObject = Get-Item -Path $home

        $FileObject | Should -BeOfType __

        $Object = $FileObject | Select-Object -Property FullName, Name, DirectoryName
        $Object | Should -BeOfType __
    }

    It 'can retrieve just the contents or value of a property' {
        $FileObject = Get-Item -Path $home

        $FileName = $FileObject | Select-Object -ExpandProperty __ -ErrorAction SilentlyContinue

        $FileName | Should -Be $FileObject.Name
    }

    It 'can pick specific numbers of objects' {
        $Array = 1..100

        $FirstThreeValues = __
        $Array | Select-Object -First 3 | Should -Be $FirstThreeValues

        $LastFourValues = __
        $Array | Select-Object -Last 4 | Should -Be $LastFourValues

        $Array | Select-Object -Skip 10 -First 5 | Should -Be __
    }

    It 'can ignore duplicate objects' {
        $Array = 6, 1, 4, 8, 7, 5, 3, 9, 2, 3, 2, 1, 5, 1, 6, 2, 8, 4,
        7, 3, 1, 2, 6, 3, 7, 1, 4, 5, 2, 1, 3, 6, 2, 5, 1, 4

        $UniqueItems = 5, '__', 10, 9, '__', '__', '__', 7, '__', '__'
        $Array | Select-Object -Unique | Should -Be $UniqueItems
    }
}