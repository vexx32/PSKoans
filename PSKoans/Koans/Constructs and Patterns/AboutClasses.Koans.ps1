using module PSKoans
[Koan(Position = 311)]
param()
<#
    About Classes

    A class in .NET might be considered to be the recipe used to create a type. A type
    is a representation of something, anything. Types in .NET and PowerShell are used
    to describe everything from strings and numbers to Files, Folders, and Processes.

    PowerShell gained the ability to create classes in PowerShell 5.0, and this support
    continues into PowerShell Core.

    Like the "About Enumerations" topic, jobs are used to isolate example code, preventing it
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

                [Car]::new()

                <#
                    The New-Object command can also create an instance.

                    New-Object -TypeName 'Car'
                #>
            }

            $expectedTypeName = '____'

            $car = Start-Job -ScriptBlock $script | Receive-Job -Wait -ErrorAction Stop
            $car.PSTypeNames[0] | Should -Match $expectedTypeName
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
                PowerShell jobs run in a separate process, so values returned by a job are serialized,
                changed into a format which can be sent between two processes. Outside of the job the copy
                of the object is a PSCustomObject which only includes the Properties from the original.

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

        It 'can define a type for each property' {
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
            Methods are used to execute predefined actions. This may be changing a property of the object itself, or
            a change to the the thing the object represents, or it might be used to generate something new from the
            object.
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

                            Please do not change the value below!
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
                        New-Item -Path $this.Path -ItemType File -Value 'FileContent' -Force
                    }
                }

                $file = [File]@{
                    Path = Join-Path -Path $using:TestDrive -ChildPath 'file.txt'
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

                    [void] Create([String] $content) {
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
            $Path | Should -FileContentMatch $Content
        }

        It 'can describe methods which return objects' {
            $script = {
                class File {
                    [string] $Path

                    [void] Create([String] $content) {
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
                Sometimes it is desirable for a method to behave differently if different arguments
                are passed.

                Each variation of the method is given the same name, but each variation needs to
                accept a unique set of argument types.

                Each method overload must have a unique signature, derived from the number and types of its arguments.
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
                    Create([String] $content) {
                        # Please do not change the value below!
                        if ($content -ne '____') {
                            $this.SelectedMethod = 'With content'
                            New-Item -Path $this.Path -ItemType File -Value $Content -Force
                        }
                    }
                }

                $file = [File]@{
                    Path = Join-Path -Path $using:TestDrive -ChildPath 'File.txt'
                }

                if ($using:Argument) {
                    $file.Create($using:Argument)
                }
                else {
                    $file.Create()
                }
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

        It 'can describe common methods such as ToString' {
            <#
                All objects and types have a method called ToString. By default the method returns the name of the
                type only.

                The default method can be overridden by adding it to the class as shown below.

                The ToString method will also be used when the class is cast to a string.
            #>

            $script = {
                class File {
                    [string] $Path

                    [string] ToString() {
                        return $this.Path
                    }
                }

                $file = [File]@{
                    Path = 'C:\Path'
                }
                $file.ToString()
            }

            '____' | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }
    }

    Context 'Constructors' {
        <#
            The constructor can be used to perform actions when an instance of a type is created. It can also be used
            to accept arguments when creating the type.

            A constructor is a specialised method which is named after the class. It does not use the
            "return" keyword, it implicitly returns an instance of the type.

            Classes which do not explicitly declare a constructor have a default constructor. This does not require any
            arguments and does not perform any actions.
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

                    Employee([string] $name) {
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
            # Just like methods, constructors can be overloaded. Each constructor overload must have a unique signature.

            $script = {
                class Employee {
                    [string] $Name
                    [string] $JobTitle
                    [int]    $EmployeeNumber

                    # Shows which constructor was used when creating an instance of this type.
                    [string] $SelectedConstructor

                    # This constructor is selected when the argument is a String.
                    Employee([string] $name) {
                        $this.Name = $name

                        # Avoid marking the default value as the correct answer!
                        if ($name -ne '____') {
                            $this.SelectedConstructor = 'String'
                        }
                    }

                    # This constructor is selected when the argument is an Int32.
                    Employee([int] $employeeNumber) {
                        $this.EmployeeNumber = $employeeNumber
                        $this.SelectedConstructor = 'Int'
                    }
                }

                [Employee]::new($using:Argument)
            }

            $Argument = '____'

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

                    Employee([string] $name) {
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

            Static properties and methods can be called without first creating an instance of the type.

            .NET includes many static properties and methods. For example, the DateTime type has several of both.
            Static members can be shown using Get-Member:

                [DateTime] | Get-Member -Static
        #>

        It 'can use the Static keyword to create static methods' {
            $script = {
                class Path {
                    static [string] GetHomePath() {
                        return Resolve-Path ~
                    }
                }

                [Path]::GetHomePath()
            }

            $expectedPath = '____'

            Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -Be $expectedPath
        }

        It 'can use the Static keyword for a property' {
            <#
                Static properties can have a fixed value, or a value based on the result of executing
                a PowerShell statement.
            #>
            $script = {
                class Path {
                    static [string] $HomePath = (Resolve-Path ~)
                }

                [Path]::HomePath
            }

            $expectedPath = '____'

            Start-Job -ScriptBlock $script | Receive-Job -Wait | Should -Be $expectedPath
        }

        It 'cannot access the static member using $this' {
            # Static methods and properties are accessed using the type name from within the class.

            $script = {
                class Path {
                    static [string] $HomePath = (Resolve-Path ~)

                    [string] $Name
                    [string] $Parent
                    [bool]   $IsHomePath

                    Path([string] $Path) {
                        if (Test-Path -Path $Path) {
                            $Path = Resolve-Path -Path $Path
                        }

                        $this.Name = Split-Path -Path $Path -Leaf
                        $this.Parent = Split-Path -Path $Path -Parent

                        # The HomePath static property must be accessed using the class name. $this.HomePath cannot be used.
                        $this.IsHomePath = $Path -eq [Path]::HomePath
                    }
                }

                $path = [Path]::new('~')
                $path.IsHomePath
            }

            $____ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }
    }

    Context 'About Hidden' {
        <#
            The hidden keyword stops a property or method from being offered by tab completion. It also hides the property
            from Get-Member, except when the Force parameter is used.
        #>

        It 'can hide a property from casual view' {
            $script = {
                class Secret {
                    [string] $Name
                    hidden [string] $Value
                }

                $secret = [Secret]@{
                    Name  = 'Password'
                    Value = 'hunter2'
                }

                $secret.PSObject.Properties.Name
            }

            @('____') | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        It 'can still access hidden properties' {
            <#
                Hiding properties does not provide any degree of secrecy. Hidden properties are still accessible
                by name.
            #>

            $script = {
                class Secret {
                    [string] $Name
                    hidden [string] $Value
                }

                $secret = [Secret]@{
                    Name  = 'Password'
                    Value = 'hunter2'
                }

                $secret.Value
            }

            '____' | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }
    }

    Context 'Inheritance' {
        <#
            A class can inherit from another class. The class may be written in PowerShell, from elsewhere in the .NET
            framework, or from another assembly.

            A class may inherit from one other class only.

            The syntax for class inheritance is:

                class <Name> : <InheritedType>
        #>

        It 'can inherit from a parent class' {
            $script = {
                # The parent class can implement constructors, properties, and methods common to all child classes.
                class Pet {
                    [string] $Diet        = 'Herbivore'
                    [int]    $HungerLevel = 100

                    [Void] Feed([int] $amount) {
                        $this.HungerLevel -= $amount
                        if ($this.HungerLevel -lt 0) {
                            $this.HungerLevel = 0
                        }
                    }
                }

                # This specific implementation of the Pet class does not deviate from the parent class yet.
                class Rabbit : Pet { }

                $rabbit = [Rabbit]::new()
                $rabbit.Feed(20)
                $rabbit.HungerLevel
            }

            __ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        It 'can override members in a child class' {
            $script = {
                class Pet {
                    [string] $Diet        = 'Herbivore'
                    [int]    $HungerLevel = 100

                    [Void] Feed() {
                        $this.HungerLevel = 0
                    }
                }

                class Dog : Pet {
                    # This property automatically overrides the Diet property defined by the parent class.
                    [string] $Diet = 'Carnivore'
                }

                $dog = [Dog]::new()
                $dog.Feed()
                $dog.HungerLevel
            }

            __ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        It 'can use constructors from the parent class' {
            <#
                The methods and properties of a parent class are accessed using the $this variable.

                Constructors are also inherited.

                If a child class needs to perform additional actions when a constructor is executed it
                may use the base keyword.
            #>

            $script = {
                class Pet {
                    [string] $Diet        = 'Herbivore'
                    [int]    $HungerLevel

                    Pet() {
                        $this.HungerLevel = Get-Random -Minimum 0 -Maximum 101
                    }
                }

                class Dog : Pet {
                    Dog() : base() {
                        # The code here runs after the code in the constructor in the parent class.
                        $this.Diet = 'Carnivore'
                    }
                }

                $dog = [Dog]::new()
                $dog.Diet
            }

            '____' | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        It 'can pass arguments to a constructor from a parent class' {
            $script = {
                class Pet {
                    [string] $Diet        = 'Herbivore'
                    [int]    $HungerLevel

                    Pet() {
                        $this.Diet = 'Herbivore'
                    }

                    Pet([string] $diet, [int] $hungerLevel) {
                        $this.Diet = $diet
                        $this.HungerLevel = $hungerLevel
                    }
                }

                class Dog : Pet {
                    <#
                        Arguments passed to a constructor on the parent can be variable, hard-coded or a mix
                        of the two.
                    #>
                    Dog([int] $hungerLevel) : base('Carnivore', $hungerLevel) {
                        <#
                            This constructor does not implement any extra logic. It is only used to pass a default
                            value for one of the arguments.
                        #>
                    }
                }

                $dog = [Dog]::new(20)
                $dog.Diet
            }

            '____' | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }
    }

    Context 'Comparison and Equality' {
        <#
            An instance of a type can be compared to another instance of a type by implementing
            a number of different methods. The methods are defined by interfaces.

                IComparable - Provides support for -gt, -lt, -ge, and -le.
                IEquatable - Provides support for -eq, and -ne.

            A class might support IEquatable but not IComparable for example.

            Interfaces are added using inheritance syntax. A class may inherit one other class, but can
            inherit multiple interfaces.
        #>

        It 'can support comparison' {
            $script = {
                class VideoGame : IComparable {
                    [string] $Name
                    [string] $Publisher
                    [int]    $Rating

                    <#
                        The IComparable interface makes implementation of the CompareTo method mandatory.

                        The CompareTo method must accept an argument with type [object], and must return 1, 0, or -1.

                            -1: The current instance precedes the object specified.
                            0: The current instance is in the same position as the object specified.
                            1: The current object follows the object specified.
                    #>
                    [int] CompareTo([Object] $object) {
                        if ($this.Rating -eq $object.Rating) {
                            return 0
                        }
                        elseif ($this.Rating -gt $object.Rating) {
                            return 1
                        }
                        else {
                            return -1
                        }
                    }
                }

                $game1 = [VideoGame]@{
                    Name      = 'Grim Fandango'
                    Publisher = 'LucasArts'
                    Rating    = 94
                }
                $game2 = [VideoGame]@{
                    Name      = 'Day of the Tentacle'
                    Publisher = 'Double Fine Productions'
                    Rating    = 86
                }

                <#
                    If the Rating properties are made equal, both -ge and -le will return true. However, -eq
                    will return false because the class is not IEquatable.
                #>
                $game1 -gt $game2
            }

            $____ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        It 'can support equality' {
            $script = {
                <#
                    The IEquatable interface requires a type, and that should be the same type name as the class
                    it is comparing. However, PowerShell will not agree that type exists at the point it needs to
                    be used.

                    To work around this problem, the equatable type can be set to Object and the test for object
                    type can be moved into the method.
                #>

                class VideoGame : IEquatable[object] {
                    [string] $Name
                    [string] $Publisher
                    [int]    $Rating

                    <#
                        The IEquatable interface makes implementation of the Equals method mandatory.

                        The Equals method must accept an argument with a type equal to the type in the inheritance
                        statement. The method must return a boolean; $true or $false.
                    #>
                    [bool] Equals([object] $object) {
                        # If the object is not a VideoGame, immediately return false.
                        if ($object -isnot [VideoGame]) {
                            return $false
                        }

                        # Objects are considered equal if the expression below returns true.
                        return $this.Name -eq $object.Name -and $this.Publisher -eq $object.Publisher
                    }
                }

                $game1 = [VideoGame]@{
                    Name      = 'Grim Fandango'
                    Publisher = 'LucasArts'
                    Rating    = 94
                }
                $game2 = [VideoGame]@{
                    Name      = 'Day of the Tentacle'
                    Publisher = 'Double Fine Productions'
                    Rating    = 86
                }

                $game1 -eq $game2
            }

            $____ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        It 'can support both equality and comparison' {
            $script = {
                class VideoGame : IComparable, IEquatable[Object] {
                    [string] $Name
                    [string] $Publisher
                    [int]    $Rating

                    [int] CompareTo([Object] $object) {
                        if ($this.Rating -eq $object.Rating) {
                            return 0
                        }
                        elseif ($this.Rating -gt $object.Rating) {
                            return 1
                        }
                        else {
                            return -1
                        }
                    }

                    [bool] Equals([Object] $object) {
                        if ($object -isnot [VideoGame]) {
                            return $false
                        }
                        <#
                            If equality is based on the same comparison as IComparable, that is CompareTo being 0,
                            the following expression might be used:

                                return $this.CompareTo($object) -eq 0
                        #>
                        return $this.Name -eq $object.Name -and $this.Publisher -eq $object.Publisher
                    }
                }

                $game1 = [VideoGame]@{
                    Name      = 'Grim Fandango'
                    Publisher = 'LucasArts'
                    Rating    = 94
                }
                $game2 = [VideoGame]@{
                    Name      = 'Day of the Tentacle'
                    Publisher = 'Double Fine Productions'
                    Rating    = 86
                }

                $game1 -eq $game2
            }

            $____ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }
    }

    Context 'Casting' {
        <#
            Casting a value to a PowerShell class type can be supported by adding a constructor which takes an
            object of the value's type as an argument.
        #>

        It 'can use a constructor to support casting' {
            $script = {
                class Number {
                    [string] $Name
                    [int]    $Value

                    Number([int] $number) {
                        $this.Value = $number
                        $this.Name = switch ($number) {
                            1       { 'one' }
                            2       { 'two' }
                            3       { 'three' }
                            default { throw 'Sorry, I can only count to 3' }
                        }
                    }
                }

                $number = [Number]2
                $number.Name
            }

            '____' | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        <#
            PowerShell classes can be cast to another type by implementing a method named op_Implicit in a class.
            The syntax for op_Implicit is as follows:

                static <TargetType> op_Implicit(<TypeToConvert>) { <Implementation> }
        #>

        It 'allows an instance of a class to be cast to another value using op_Implicit' {
            $script = {
                class Number {
                    [string] $Name
                    [int]    $Value

                    # The op_Implicit method will be triggered when an attempt is made to cast to [int]
                    hidden static [int] op_Implicit([Number] $number) {
                        return $number.Value
                    }
                }

                $number = [Number]@{
                    Name  = 'three'
                    Value = 3
                }
                [int]$number
            }

            __ | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }

        <#
            The op_Implicit method is able to convert both from a type to the class, and from the class to a
            type.
        #>

        It 'can use op_Implicit to convert from another value type' {
            $script = {
                class Number {
                    [string] $Name
                    [int]    $Value

                    # Allows casting from an Int to Number.
                    hidden static [Number] op_Implicit([int] $value) {
                        return [Number]@{
                            Value = $value
                            Name = switch ($value) {
                                1       { 'one' }
                                2       { 'two' }
                                3       { 'three' }
                                default { throw 'Sorry, I can only count to 3' }
                            }
                        }
                    }
                }

                ([Number]2).Name
            }

            '____' | Should -Be (Start-Job -ScriptBlock $script | Receive-Job -Wait)
        }
    }
}
