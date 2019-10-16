using module PSKoans
[Koan(Position = 311)]
param()
<#
    About Classes

    A class in .NET might be considered to be the recipe used to create a type. A type
    is a representation of something, anything. Types are used to describe everything,
    from strings and numbers to Files, Folders, and Processes.

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

    Context 'Constructors' {

    }

    Context 'Methods' {

    }

    Context 'Static Properties and Methods' {

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
