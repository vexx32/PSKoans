using module PSKoans
[Koan(Position = 311)]
param()
<#
    About Classes

    A class in .NET might be considered to be the recipe used to create a type. A type
    is a representation of something, anything. Types in .NET and PowerShell are used
    to describe everything from strings and numbers to Files, Folders, and Processes.

    PowerShell gained the ability to create classes in PowerShell 5.0, this support
    continues into PowerShell Core.

    Like the "About Enumerations" topic, jobs are used to isolate example code. Preventing it
    from affecting the current PowerShell session. The classes created in Start-Job cannot be
    directly used outside of the Start-Job script.
#>
Describe 'About Classes' {
    Context 'Classes and Properties' {
        It 'can create simple classes using the class keyword' {
            <#
                Classes are created using the Class keyword.

                A class can be used to describe just about anything.
            #>

            $script = {
                # This class has no members, properties, or methods.

                class Car { }

                # An instance of the Car class can be created using ::new().

                [____]::new()

                # The New-Object command can also be used.

                New-Object '____'
            }

            { Start-Job -ScriptBlock $script | Receive-Job -Wait -ErrorAction Stop } |
                Should -Not -Throw
        }

        It 'can declare properties' {
            $script = {
                # Properties are used to describe different information about an object.

                class Car {
                    $Make
                    $Model
                }

                # Properties can be assigned a value once the object has been created.

                $car = [Car]::new()
                $car.Make = 'Austin'
                $car.Model = 'Allegro'

                $car
            }

            <#
                PowerShell jobs run in a separate process, values returned by a job a serialized, that is
                changed into a format which can be sent between two processes. Outside of the job the copy
                of the object is a PSCustomObject which includes the Properties only.

                The instance of Car returned by the job will have the same properties as the class.
            #>

            $car = Start-Job -ScriptBlock $script | Receive-Job -Wait

            '____' | Should -Be $car.Make
            '____' | Should -Be $car.Model
        }

        It 'can create instances of a type from a hashtable' {
            $script = {
                class Car {
                    $Make
                    $Model
                }

                <#
                    A hashtable can be used to fill the properties of an object when the object is created.

                    The limitations of this approach will be explored along with constructors later in this topic.
                #>

                [Car]@{
                    Make  = 'Ford'
                    Model = 'Model T'
                }
            }

            $car = Start-Job -ScriptBlock $script | Receive-Job -Wait

            '____' | Should -Be $car.Make
            '____' | Should -Be $car.Model
        }

        It 'can define a type name for a property' {
            $script = {
                class Car {
                    $Make
                    [string] $Model
                }

                $car = [Car]@{
                    Make  = 'Volkswagon'
                    Model = 'Golf'
                }

                <#
                    Properties which do not have an explicit type name defined are given the type System.Object.

                    Get-Member can be used to see the property type defined by the class.
                #>

                $property = $car | Get-Member -Name $using:PropertyName
                $typeName, $null = $property.Definition -split ' '

                $typeName
            }

            $PropertyName = '____'
            $ExpectedTypeName = 'System.Object'

            Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -Be $ExpectedTypeName

            $PropertyName = 'Model'
            $ExpectedTypeName = '____'

            Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -Be $ExpectedTypeName
        }
    }

    Context 'Methods' {
        <#
            Methods are to change things. This change can be to a property of the object itself, or a change to the
            the thing the object represents, or it might be used to generate something new from the object.
        #>

        It 'can describe methods which do not return anything' {
            $script = {
                class File {
                    [string] $Path

                    # This method creates a file but does not return any values.
                    Create() {
                        <#
                            The special variable $this is used to refer to the properties created in the class.

                            In PowerShell $this must be used when getting or setting values for a property in a method.
                        #>
                        if ($this.Path -like '*____') {
                            throw 'Invalid path!'
                        }
                        <#
                            New-Object returns a value when run. In a PowerShell Function, if the value is not wanted as
                            output, it needs to be assigned or sent to null.

                            In a method in a PowerShell class nothing is returned from a method without explicit use of the
                            return keyword. Return is explored later in this topic.
                        #>
                        New-Item -Path $this.Path -ItemType File -Value 'FileContent' -Force
                    }
                }

                $file = [File]@{
                    Path = Join-Path -Path $using:TestDrive -ChildPath $using:FileName
                }

                $file.Create()
            }

            $FileName = '____'

            { Start-Job -ScriptBlock $script | Receive-Job -Wait -ErrorAction Stop } |
                Should -Not -Throw -ExpectedMessage 'Invalid path!'
            Join-Path -Path $TestDrive -ChildPath $FileName | Should -Exist
        }

        It 'can use Void to clearly indicate a method does not return a value' {
            $script = {
                class File {
                    [string] $Path

                    # The type Void can optionally be used to explicitly state that a method does not return a value.
                    [void] Create() {
                        if ($this.Path -like '*____') {
                            throw 'Invalid path!'
                        }
                        New-Item -Path $this.Path -ItemType File -Value 'FileContent' -Force
                    }
                }

                $file = [File]@{
                    Path = Join-Path -Path $using:TestDrive -ChildPath $using:FileName
                }

                $file.Create()
            }

            Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -BeNullOrEmpty
        }

        It 'can describe methods which accept arguments' {
            # A method in a class can be assigned one or more arguments.
            $script = {
                class File {
                    [string] $Path

                    [void] Create(
                        [String] $content
                    ) {
                        New-Item -Path $this.Path -ItemType File -Value $content -Force
                    }
                }

                $file = [File]@{
                    Path = $using:Path
                }
                $file.Create('Hello world')
            }

            $Content = '____'

            $Path = Join-Path -Path $TestDrive -ChildPath 'File.txt'

            Start-Job -ScriptBlock $script | Receive-Job -Wait

            $Path | Should -Exist
            $Path | Should -Contain $Content
        }

        It 'can describe methods which return objects' {
            $script = {
                class File {
                    [string] $Path

                    [void] Create(
                        [String] $content
                    ) {
                        New-Item -Path $this.Path -ItemType File -Value $Content -Force
                    }

                    [String[]] ReadAll() {
                        # The return keyword must be used to return a value from the method.
                        return [System.IO.File]::ReadAllLines($this.Path)
                    }
                }

                $file = [File]@{
                    Path = $using:Path
                }

                $file.Create('Hello world')
                $file.ReadAll()
            }

            $Content = '____'

            $Path = Join-Path -Path $TestDrive -ChildPath 'File.txt'

            Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -Be $Content
        }

        It 'can overload methods' {
            <#
                Sometimes it is desirable for a method to behave differently a different argument
                is passed.

                Each variation of the method is given the same name, but each variation needs to
                accept a unique set of argument types.

                Each method has a Signature derived from the number and types of its arguments.
            #>
            $script = {
                class File {
                    [string] $Path

                    # This property is used to show which of the overloaded methods was used.
                    [string] $SelectedMethod

                    # This method does not require any arguments.
                    [void] Create() {
                        $this.SelectedMethod = 'No content'

                        New-Item -Path $this.Path -ItemType File -Force
                    }

                    # This method will be used if a single string is passed as an argument.
                    Create(
                        [String] $content
                    ) {
                        if ($content -ne '____') {
                            $this.SelectedMethod = 'With content'
                            New-Item -Path $this.Path -ItemType File -Value $Content -Force
                        }
                    }
                }

                $file = [File]@{
                    Path = $using:Path
                }

                $file.Create($using:Argument)
                $file
            }

            # If there are no arguments
            $Argument = $null
            $file = Start-Job -ScriptBlock $script | Receive-Job -Wait

            '____' | Should -Be $file.SelectedMethod

            # If a string is supplied, and the string is not this default value
            $Argument = '____'

            $file = Start-Job -ScriptBlock $script | Receive-Job -Wait
            'With content' | Should -Be $file.SelectedMethod
        }
    }

    Context 'Constructors' {
        <#
            The constructor can be used to perform actions when an instance of a type is created. A constructor
            can also be used to accept arguments when creating the type.

            A constructor is a specialised method which is named after the class. A constructor does not use the
            "return" keyword. The constructor implicitly returns an instance of the type.

            Classes which do not explicitly declare a constructor have a default constructor. The default constructor
            does not require any arguments and does not perform any actions.
        #>

        It 'uses the same name as the class to describe a constructor' {
            $script = {
                class Employee {
                    [string] $Name
                    [string] $JobTitle
                    [int]    $EmployeeNumber

                    # This constructor expects a value for the argument Name.
                    Employee($name) {
                        $this.Name = $name

                        # The constructor can perform any actions required to set up the initial state of the object.
                    }
                }

                [Employee]::new($using:Name)
            }

            $Name = '____'

            $Employee = Start-Job -ScriptBlock $script | Receive-Job -Wait
            $Employee.Name | Should -Be $Name
        }

        It 'removes the default constructor when a specific constructor is added' {
            $script = {
                class Employee {
                    [string] $Name
                    [string] $JobTitle
                    [int]    $EmployeeNumber

                    Employee(
                        [string] $name
                    ) {
                        $this.Name = $name
                    }
                }

                [Employee]::new()
            }

            $ExpectedError = '____'

            { Start-Job -ScriptBlock $script | Receive-Job -Wait -ErrorAction Stop } |
                Should -Throw -ExpectedMessage $ExpectedError
        }

        It 'can declare more than one constructor' {
            # More than one constructor can be created. Each constructor must have a unique signature.

            $script = {
                class Employee {
                    [string] $Name
                    [string] $JobTitle
                    [int]    $EmployeeNumber

                    # Shows which constructor was used when creating an instance of this type.
                    [string] $SelectedConstructor

                    # This constructor is selected when the argument is a String.
                    Employee(
                        [string] $name
                    ) {
                        $this.Name = $name

                        # Avoid marking the default value as the correct answer!
                        if ($name -ne '____') {
                            $this.SelectedContructor = 'String'
                        }
                    }

                    # This constructor is selected when the argument is an Int32.
                    Employee(
                        [int] $employeeNumber
                    ) {
                        $this.EmployeeNumber = $employeeNumber
                        $this.SelectedConstructor = 'Int'
                    }
                }

                [Employee]::new($using:Argument)
            }

            $Argument = '___'

            $Employee = Start-Job -ScriptBlock $script | Receive-Job -Wait
            $Employee.SelectedConstructor | Should -Be 'String'

            $Argument = __

            $Employee = Start-Job -ScriptBlock $script | Receive-Job -Wait
            $Employee.SelectedConstructor | Should -Be 'Int'
        }

        It 'allows a new default constructor to be added' {
            $script = {
                class Employee {
                    [string] $Name
                    [string] $JobTitle
                    [int]    $EmployeeNumber

                    [string] $SelectedConstructor

                    # The new default constructor should not expect arguments.
                    Employee() {
                        # The constructor can execute any actions needed to set the initial state of the object.
                        $this.SelectedConstructor = 'Default'
                    }

                    Employee(
                        [string] $name
                    ) {
                        $this.Name = $name
                        $this.SelectedConstructor = 'String'
                    }
                }

                [Employee]::new()
            }

            $Constructor = '____'

            $Employee = Start-Job -ScriptBlock $script | Receive-Job -Wait
            $Employee.SelectedConstructor | Should -Be $Constructor
        }
    }

    Context 'Static Properties and Methods' {
        <#
            Each of the methods used so far have needed an instance of the type to be created.

            Static properties and methods can be called without first creating an instance of the
        #>
    }

    Context 'About Hidden' {

    }

    Context 'Inheritance' {

    }

    Context 'Comparison and Equality' {

    }

    Context 'Casting' {

    }
}
