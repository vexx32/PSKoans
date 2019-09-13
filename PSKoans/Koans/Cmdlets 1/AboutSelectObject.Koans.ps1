using module PSKoans
[Koan(Position = 205)]
param()
<#
    Select-Object

    Select-Object is a utility cmdlet which serves a number of different purposes.

        * Select or skip a fixed number of objects from a pipeline
        * Select unique objects from an array or collection
        * Select individual properties from an object
        * Create a new object with additional, custom, properties
#>
Describe 'Select-Object' {
    It 'can select specific properties from an object' {
        <#
            Select-Object can accept an array of property names and creates a
            new custom object using those properties.
        #>

        $Selected = Get-Proces -Id $PID | Select-Object Name, ID, Path

        @('__', '__', 'Path') | Should -Be $Selected.PSObject.Properties.Name

        $Selected.____ | Should -Be $PID
    }

    It 'can exclude specific properties from an object' {
        <#
            Individual properties can be excluded from a selection.

            Both the Property and ExcludeProperty parameters support wildcards.
        #>

        $Folder = Get-Item -Path $PSHome

        '__' | Should -Be $Selected.Attributes

        $Selected = $Folder | Select-Object -Property * -ExcludeProperty Attributes

        $Selected.Attributes | Should -BeNullOrEmpty
    }

    It 'changes the object type' {
        <#
            When properties are selected from an object a new custom object is created.

            The new object is also tagged with a PSTypeName derived from the original type name.
        #>

        $Folder = Get-Item -Path $PSHome

        $Selected.GetType().FullName | Should -BeOfType [System.IO.Directoryinfo]

        'System.IO.Directoryinfo' | Should -BeIn $Folder.PSTypeNames

        <#
            The new selected object is an instance of [System.Management.Automation.PSCustomObject].
        #>

        $Selected = $Folder | Select-Object -Property * -ExcludeProperty Attributes

        $Selected.GetType().FullName | Should -BeOfType [System.Management.Automation.PSCustomObject]

        '___' | Should -BeIn $Selected.PSTypeNames

        <#
            [System.Management.Automation.PSCustomObject] type should not be confused with commonly used
            [PSCustomObject] type behind the accelerator.
        #>

        [System.Management.Automation.PSCustomObject] | Should -Not -Be [PSCustomObject]
    }

    It 'can retrieve just the contents or value of a property' {
        <#
            Individual properties can be expanded, retrieving the just a value.
        #>

        $PropertyToExpand = '___'

        $Value = Get-Item -Path $PSHome | Select-Object -ExpandProperty $PropertyToExpand

        $Value | Should -Be 'Directory'
    }

    It 'can merge the properties of a nested object with properties from the parent' {
        <#
            The ExpandProperty parameter can be used to "move" the properties of a nested
            property up to a new parent object.
        #>

        $PowerShellExe = Get-Item (Get-Process -Id $PID | Select-Object -ExpandProperty Path)

        $Selected = $PowerShellExe | Select-Object Name -ExpandProperty VersionInfo

        <#
            The resulting object will contain all of the properties found under VersionInfo.
        #>

        $Selected.__ | Should -Be $PowerShellExe.FullName
    }

    It 'can pick specific numbers of objects' {
        $Array = 1..100

        $FirstThreeValues = $Array | Select-Object -First 3
        __ | Should -Be $FirstThreeValues

        $LastFourValues = $Array | Select-Object -Last 4
        __ | Should -Be $LastFourValues

        $Values = $Array | Select-Object -Skip 10 -First 5
        __ | Should -Be $Values

        <#
            SkipLast cannot be used alongside the Last, First, and Skip parameters.
        #>

        $Values = $Array | Select-Object -SkipLast 95
        ___ | Should -Be $Values
    }

    It 'can ignore duplicate objects' {
        <#
            Select-Object can be used to create a unique list.
        #>

        $Array = 6, 1, 4, 8, 7, 5, 3, 9, 2, 3, 2, 1, 5, 1, 6, 2, 8, 4,
        7, 3, 1, 2, 6, 3, 7, 1, 4, 5, 2, 1, 3, 6, 2, 5, 1, 4

        $UniqueItems = $Array | Select-Object -Unique
        6, '__', 4, 8, '__', '__', 3, '__', 2 | Should -Be $UniqueItems
    }

    It 'can ignore duplicate complex objects' {
        <#
            Unique works on some more complex objects.

            Ideally objects should be directly comparable, although this is
            rare outside of Strings, numeric types, enumeration types, and other value types.

            Select-Object falls back on the ToString method of an object.
        #>

        $Processes = (Get-Process -Id $PID), (Get-Process -Id $PID)

        __ | Should -Be $Processes.Count

        $UniqueProcesses = $processes | Select-Object -Unique

        __ | Should -Be $UniqueProcesses.Count

        <#
            Processes are made unique based on comparing the value returned by running:

                (Get-Process -Id $PID).ToString()

            This value includes the name of the process, but not the
            ProcessId.

            If several processes of the name name are running these
            will be removed by the Unique parameter.
        #>
    }

    It 'maintains the original object type when the Property parameter is not used' {
        <#
            When the Property parameter is used, a new object
        #>

        $Files = Get-ChildItem -Path $PSHome -File

        $SelectedFile = $Files | Select-Object -First 1

        '___' | Should -Be $SelectedFile.GetType().FullName
    }

    It 'supports custom, or calculated, properties' {
        <#
            The property parameter can read a hashtable which describes a property.

            The hashtable requires a Name, and Expression to calculate a value for the property.

            The Expression is most often a script block, a short script enclosed in curly braces.
        #>

        $Selected = Get-Process -Id $PID | Select-Object @(
            'Name'
            'Id'
            @{ Name = 'RunningTime'; Expression = { (Get-Date) - $_.StartTime } }
        )

        $Selected.__ | Should -BeGreaterThan 0

        <#
            Custom properties are often used to merge information from multiple sources into
            a single object.
        #>

        $Selected = Get-Process -Id $PID | Select-Object @(
            'Name'
            'Id'
            @{ Name = 'RunningTime'; Expression = { (Get-Date) - $_.StartTime } }
            @{ Name = 'Size'; Expression = { (Get-Item $_.Path).Length } }
        )
    }

    It 'does not need a script block when renaming a property' {
        <#
            When renaming a property, a string with the existing property name can be used in place of the
            script block.
        #>

        $Process = Get-Process -Id $PID
        $Selected = $Process | Select-Object @(
            'Name'
            @{ Name = 'ProcessId'; Expression = 'Id' }
        )

        $Selected.__ | Should -Be $Process.Id
    }

    It 'allows Label to be used instead of Name' {
        $Process = Get-Process -Id $PID
        $Selected = $Process | Select-Object @(
            'Name'
            @{ Label = 'ProcessId'; Expression = 'Id' }
        )

        $Selected.__ | Should -Be $Process.Id
    }

    It 'supports abbreviated names in a calculated property' {
        <#
            Select-Object supports shorthand for the keys in the hashtable.

                * Name can be abbreviated to n
                * Label can be abbreviated to l
                * Expression can be abbreviated to e

            Properties are calculated when Select-Object runs, they are not updated or recalculated later.
        #>

        $Selected = Get-Process -Id $PID | Select-Object @(
            'Name'
            'Id'
            @{ n = 'Size'; e = { (Get-Item $_.Path).Length } }
        )

        $Selected.__ | Should -BeOfType [TimeSpan]
    }
}
